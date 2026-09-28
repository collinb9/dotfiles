import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test, type TestContext } from "node:test";
import { editPrompt } from "../editor.ts";

function fixture(t: TestContext) {
	const directory = mkdtempSync(join(tmpdir(), "prompt-context-test-"));
	t.after(() => rmSync(directory, { recursive: true, force: true }));
	const env = {
		...process.env, PATH: directory, TMUX: "/test/tmux", TMUX_PANE: "%1", TEST_DIR: directory,
	};
	const warnings: string[] = [];
	const renderedWidths: number[] = [];
	const script = (name: string, content: string) => {
		const path = join(directory, name);
		writeFileSync(path, `#!${process.execPath}\n${content}`, { mode: 0o700 });
		return path;
	};

	script("less", "process.exit(0);");
	script("tmux", `
		const fs = require("node:fs");
		const path = require("node:path");
		const args = process.argv.slice(2);
		fs.appendFileSync(path.join(process.env.TEST_DIR, "tmux.log"), JSON.stringify(args) + "\\n");
		if (args[0] === "display-message") {
			console.log(fs.existsSync(path.join(process.env.TEST_DIR, "zoom")) ? "1" : "0");
		} else if (args[0] === "split-window") {
			fs.rmSync(path.join(process.env.TEST_DIR, "zoom"), { force: true });
			if (fs.existsSync(path.join(process.env.TEST_DIR, "split-fails"))) {
				console.error("no space for new pane");
				process.exit(1);
			}
			console.log("%42\\t" + (fs.existsSync(path.join(process.env.TEST_DIR, "bad-width")) ? "invalid" : "67"));
		} else if (args[0] === "respawn-pane") {
			if (!fs.existsSync(args.at(-1))) throw new Error("Snapshot must exist before starting less");
			if (fs.existsSync(path.join(process.env.TEST_DIR, "pager-fails"))) process.exit(1);
		} else if (args[0] === "resize-pane") {
			fs.writeFileSync(path.join(process.env.TEST_DIR, "zoom"), "");
		}
	`);
	const editor = script("editor", `
		const fs = require("node:fs");
		const path = require("node:path");
		const prompt = process.argv.at(-1);
		const directory = path.dirname(prompt);
		const transcript = path.join(directory, "conversation.ansi");
		fs.writeFileSync(path.join(process.env.TEST_DIR, "report.json"), JSON.stringify({
			prompt, original: fs.readFileSync(prompt, "utf8"),
			transcript: fs.existsSync(transcript) ? fs.readFileSync(transcript, "utf8") : null,
			directoryMode: fs.statSync(directory).mode & 0o777,
			promptMode: fs.statSync(prompt).mode & 0o777,
			transcriptMode: fs.existsSync(transcript) ? fs.statSync(transcript).mode & 0o777 : null,
			args: process.argv.slice(2, -1), cwd: process.cwd(),
		}));
		if (process.argv.includes("--wait")) {
			setInterval(() => {}, 1000);
		} else {
			fs.writeFileSync(prompt, process.argv.includes("--empty") ? "" : "Edited draft\\n");
			process.exit(process.argv.includes("--cancel") ? 1 : 0);
		}
	`);

	return {
		directory, env, warnings, renderedWidths, script,
		options: {
			cwd: directory, command: editor, prompt: "Original draft",
			renderTranscript: (width: number) => {
				renderedWidths.push(width);
				return "Conversation snapshot";
			},
			signal: new AbortController().signal, onWarning: (message: string) => warnings.push(message), env,
		},
		report: () => JSON.parse(readFileSync(join(directory, "report.json"), "utf8")),
		commands: (): string[][] => existsSync(join(directory, "tmux.log"))
			? readFileSync(join(directory, "tmux.log"), "utf8").trim().split("\n").map((line) => JSON.parse(line))
			: [],
	};
}

test("edits only the prompt and removes the pager and private files", async (t) => {
	const f = fixture(t);
	assert.equal(await editPrompt(f.options), "Edited draft");
	assert.deepEqual(f.warnings, []);
	const report = f.report();
	assert.equal(report.original, "Original draft");
	assert.equal(report.transcript, "Conversation snapshot");
	assert.equal(report.directoryMode, 0o700);
	assert.equal(report.promptMode, 0o600);
	assert.equal(report.transcriptMode, 0o600);
	assert.equal(report.cwd, f.directory);
	assert.ok(!existsSync(report.prompt));
	const split = f.commands().find((args) => args[0] === "split-window")!;
	assert.ok(split.includes("-b") && split.includes("-d") && split.includes("45%"));
	assert.equal(split.at(-1), "");
	assert.deepEqual(f.renderedWidths, [67]);
	const pager = f.commands().find((args) => args[0] === "respawn-pane")!;
	assert.deepEqual(pager.slice(-4, -1), ["less", "-R", "+G"]);
	assert.ok(pager.includes("LESSSECURE=1") && pager.includes("LESSHISTFILE=-"));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("preserves editor arguments and accepts an empty draft", async (t) => {
	const f = fixture(t);
	assert.equal(await editPrompt({ ...f.options, command: `${f.options.command} --empty` }), "");
	assert.deepEqual(f.report().args, ["--empty"]);
});

test("nonzero editor exit leaves the original draft unchanged", async (t) => {
	const f = fixture(t);
	assert.equal(await editPrompt({ ...f.options, command: `${f.options.command} --cancel` }), null);
	assert.match(f.warnings[0], /original draft is unchanged/);
	assert.ok(!existsSync(f.report().prompt));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("missing editor still removes the pager and temporary files", async (t) => {
	const f = fixture(t);
	await assert.rejects(editPrompt({ ...f.options, command: "nonexistent-editor" }), /ENOENT/);
	const transcriptPath = f.commands().find((args) => args[0] === "respawn-pane")!.at(-1)!;
	assert.ok(!existsSync(transcriptPath));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("works outside tmux without creating a pager", async (t) => {
	const f = fixture(t);
	assert.equal(await editPrompt({ ...f.options, env: { ...f.env, TMUX: "", TMUX_PANE: "" } }), "Edited draft");
	assert.deepEqual(f.commands(), []);
	assert.deepEqual(f.renderedWidths, []);
});

test("missing less falls back to editor only", async (t) => {
	const f = fixture(t);
	rmSync(join(f.directory, "less"));
	assert.equal(await editPrompt(f.options), "Edited draft");
	assert.match(f.warnings[0], /Could not start less/);
	assert.deepEqual(f.commands(), []);
});

test("a failed split falls back to the editor and restores zoom", async (t) => {
	const f = fixture(t);
	writeFileSync(join(f.directory, "zoom"), "");
	writeFileSync(join(f.directory, "split-fails"), "");
	assert.equal(await editPrompt(f.options), "Edited draft");
	assert.match(f.warnings[0], /no space for new pane/);
	assert.ok(existsSync(join(f.directory, "zoom")));
	assert.ok(!f.commands().some((args) => args[0] === "kill-pane"));
});

test("restores the original zoom after closing the pager", async (t) => {
	const f = fixture(t);
	writeFileSync(join(f.directory, "zoom"), "");
	await editPrompt(f.options);
	assert.ok(existsSync(join(f.directory, "zoom")));
	assert.deepEqual(f.commands().at(-1), ["resize-pane", "-Z", "-t", "%1"]);
});

test("a renderer failure removes the empty pane and keeps editing available", async (t) => {
	const f = fixture(t);
	assert.equal(await editPrompt({ ...f.options, renderTranscript: () => { throw new Error("render failed"); } }), "Edited draft");
	assert.match(f.warnings[0], /render failed/);
	assert.equal(f.report().transcript, null);
	assert.ok(!f.commands().some((args) => args[0] === "respawn-pane"));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("invalid pane width falls back without rendering", async (t) => {
	const f = fixture(t);
	writeFileSync(join(f.directory, "bad-width"), "");
	assert.equal(await editPrompt(f.options), "Edited draft");
	assert.deepEqual(f.renderedWidths, []);
	assert.match(f.warnings[0], /too narrow/);
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("a pager startup failure removes its pane and snapshot", async (t) => {
	const f = fixture(t);
	writeFileSync(join(f.directory, "pager-fails"), "");
	assert.equal(await editPrompt(f.options), "Edited draft");
	assert.match(f.warnings[0], /Could not start pager/);
	assert.ok(!existsSync(f.report().prompt));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});

test("passes paths containing shell metacharacters as single tmux arguments", async (t) => {
	const f = fixture(t);
	const cwd = `${f.directory}/space ' \" $dollar ;`;
	const { mkdirSync } = await import("node:fs");
	mkdirSync(cwd);
	await editPrompt({ ...f.options, cwd });
	const split = f.commands().find((args) => args[0] === "split-window")!;
	assert.equal(split[split.indexOf("-c") + 1], cwd);
	assert.equal(f.report().cwd, cwd);
});

test("aborting an active editor cleans up its pane and files", async (t) => {
	const f = fixture(t);
	const controller = new AbortController();
	const editing = editPrompt({ ...f.options, command: `${f.options.command} --wait`, signal: controller.signal });
	const rejected = assert.rejects(editing, { name: "AbortError" });
	const deadline = Date.now() + 5000;
	while (!existsSync(join(f.directory, "report.json")) && Date.now() < deadline) {
		await new Promise((resolve) => setTimeout(resolve, 20));
	}
	controller.abort();
	await rejected;
	assert.ok(!existsSync(f.report().prompt));
	assert.deepEqual(f.commands().at(-1), ["kill-pane", "-t", "%42"]);
});
