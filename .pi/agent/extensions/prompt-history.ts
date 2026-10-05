import { spawnSync } from "node:child_process";
import { readFile, readdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const SESSIONS_DIR = join(homedir(), ".pi", "agent", "sessions");

interface PromptRecord {
	text: string;
	cwd: string;
	timestamp: number;
}

async function findSessionFiles(directory: string): Promise<string[]> {
	const entries = await readdir(directory, { withFileTypes: true });
	const files = await Promise.all(
		entries.map(async (entry) => {
			const path = join(directory, entry.name);
			if (entry.isDirectory()) return findSessionFiles(path);
			return entry.isFile() && entry.name.endsWith(".jsonl") ? [path] : [];
		}),
	);
	return files.flat();
}

function textFromContent(content: unknown): string {
	if (typeof content === "string") return content;
	if (!Array.isArray(content)) return "";

	return content
		.filter(
			(block): block is { type: "text"; text: string } =>
				typeof block === "object" &&
				block !== null &&
				(block as { type?: unknown }).type === "text" &&
				typeof (block as { text?: unknown }).text === "string",
		)
		.map((block) => block.text)
		.join("\n");
}

async function readPrompts(path: string): Promise<PromptRecord[]> {
	try {
		const lines = (await readFile(path, "utf8")).split("\n");
		let cwd = "";
		const prompts: PromptRecord[] = [];

		for (const line of lines) {
			if (!line.trim()) continue;

			let entry: Record<string, unknown>;
			try {
				entry = JSON.parse(line) as Record<string, unknown>;
			} catch {
				continue;
			}

			if (entry.type === "session") {
				cwd = typeof entry.cwd === "string" ? entry.cwd : "";
				continue;
			}

			if (entry.type !== "message" || typeof entry.message !== "object" || entry.message === null) continue;

			const message = entry.message as { role?: unknown; content?: unknown; timestamp?: unknown };
			if (message.role !== "user") continue;

			const text = textFromContent(message.content).trim();
			if (!text) continue;

			const entryTime = typeof entry.timestamp === "string" ? Date.parse(entry.timestamp) : Number.NaN;
			prompts.push({
				text,
				cwd,
				timestamp:
					typeof message.timestamp === "number" && Number.isFinite(message.timestamp)
						? message.timestamp
						: Number.isNaN(entryTime)
							? 0
							: entryTime,
			});
		}

		return prompts;
	} catch {
		return [];
	}
}

function oneLine(text: string): string {
	return text.replace(/[\x00-\x1f\x7f]+/g, " ").replace(/\s+/g, " ").trim();
}

function displayPath(path: string): string {
	const home = homedir();
	return path === home || path.startsWith(`${home}/`) ? `~${path.slice(home.length)}` : path;
}

function displayDate(timestamp: number): string {
	if (!timestamp) return "unknown";
	return new Date(timestamp).toISOString().slice(0, 16).replace("T", " ");
}

async function openPromptHistory(args: string, ctx: ExtensionContext): Promise<void> {
	if (ctx.mode !== "tui") {
		ctx.ui.notify("Prompt history requires interactive TUI mode", "error");
		return;
	}

	let sessionFiles: string[];
	try {
		sessionFiles = await findSessionFiles(SESSIONS_DIR);
	} catch (error) {
		const message = error instanceof Error ? error.message : String(error);
		ctx.ui.notify(`Could not read ${SESSIONS_DIR}: ${message}`, "error");
		return;
	}

	const prompts = (await Promise.all(sessionFiles.map(readPrompts))).flat().sort((a, b) => b.timestamp - a.timestamp);

	if (prompts.length === 0) {
		ctx.ui.notify(`No prompts found under ${SESSIONS_DIR}`, "info");
		return;
	}

	const candidates = prompts
		.map(
			(prompt, index) =>
				`${index}\t${displayDate(prompt.timestamp)}\t${oneLine(displayPath(prompt.cwd))}\t${oneLine(prompt.text)}`,
		)
		.join("\0");

	let fzfError: Error | undefined;
	const selectedIndex = await ctx.ui.custom<number | null>((tui, _theme, _keybindings, done) => {
		tui.stop();
		process.stdout.write("\x1b[2J\x1b[H");

		try {
			const fzfArgs = [
				"--read0",
				"--print0",
				"--delimiter=\\t",
				"--with-nth=2..",
				"--nth=2..",
				"--layout=reverse",
				"--prompt=Prompt history> ",
				"--header=Enter: insert prompt | Esc: cancel",
			];
			const query = args.trim();
			if (query) fzfArgs.push("--query", query);

			const result = spawnSync("fzf", fzfArgs, {
				input: `${candidates}\0`,
				encoding: "utf8",
				stdio: ["pipe", "pipe", "inherit"],
			});

			if (result.error) {
				fzfError = result.error;
				done(null);
			} else if (result.status !== 0 || !result.stdout) {
				done(null);
			} else {
				const index = Number.parseInt(result.stdout.split("\t", 1)[0] ?? "", 10);
				done(Number.isInteger(index) ? index : null);
			}
		} finally {
			tui.start();
			tui.requestRender(true);
		}

		return { render: () => [], invalidate: () => {} };
	});

	if (fzfError) {
		ctx.ui.notify(`Could not start fzf: ${fzfError.message}`, "error");
		return;
	}

	if (selectedIndex !== null && prompts[selectedIndex]) {
		ctx.ui.setEditorText(prompts[selectedIndex].text);
	}
}

export default function promptHistoryExtension(pi: ExtensionAPI) {
	pi.registerCommand("prompt-history", {
		description: "Fuzzy-find prompts from every Pi session",
		handler: openPromptHistory,
	});

	pi.registerShortcut("ctrl+r", {
		description: "Open prompt history",
		handler: (ctx) => openPromptHistory("", ctx),
	});
}
