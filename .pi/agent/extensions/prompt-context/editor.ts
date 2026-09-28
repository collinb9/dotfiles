import { spawn, spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

interface EditorOptions {
	cwd: string;
	command: string;
	prompt: string;
	renderTranscript: (width: number) => string;
	signal: AbortSignal;
	onWarning: (message: string) => void;
	env?: NodeJS.ProcessEnv;
}

function tmux(args: string[], env: NodeJS.ProcessEnv) {
	return spawnSync("tmux", args, { env, encoding: "utf8", timeout: 5000 });
}

function openPager(path: string, options: EditorOptions, env: NodeJS.ProcessEnv): () => void {
	const sourcePane = env.TMUX_PANE;
	if (!env.TMUX || !sourcePane) return () => {};

	const less = spawnSync("less", ["--version"], { env, encoding: "utf8", timeout: 5000 });
	if (less.error || less.status !== 0) {
		options.onWarning("Could not start less; opening the editor without conversation history");
		return () => {};
	}

	const zoomState = () => tmux(["display-message", "-p", "-t", sourcePane, "#{window_zoomed_flag}"], env).stdout?.trim();
	const wasZoomed = zoomState() === "1";
	const restoreZoom = () => {
		if (wasZoomed && zoomState() === "0") {
			tmux(["resize-pane", "-Z", "-t", sourcePane], env);
		}
	};

	// Reserve an empty pane first so rendering uses its actual width, even when zoomed.
	// less starts only after the complete styled snapshot has been written.
	const result = tmux([
		"split-window", "-h", "-b", "-d", "-l", "45%", "-t", sourcePane,
		"-c", options.cwd, "-P", "-F", "#{pane_id}\t#{pane_width}", "",
	], env);
	const [pagerPane, paneWidth] = result.stdout?.trim().split("\t") ?? [];
	if (result.error || result.status !== 0 || !pagerPane || !/^%\d+$/.test(pagerPane)) {
		restoreZoom();
		const reason = result.error?.message || result.stderr?.trim() || "tmux failed";
		options.onWarning(`Could not open the conversation pane; opening the editor alone: ${reason}`);
		return () => {};
	}

	let closed = false;
	const close = () => {
		if (closed) return;
		closed = true;
		// The pager may already have exited via q. Only ever remove the pane we created.
		tmux(["kill-pane", "-t", pagerPane], env);
		restoreZoom();
	};
	try {
		const width = Number(paneWidth);
		if (!Number.isInteger(width) || width < 12) throw new Error("Conversation pane is too narrow");
		writeFileSync(path, options.renderTranscript(width), { mode: 0o600 });
		// Multiple command arguments make tmux execute env directly, without shell interpolation.
		const started = tmux([
			"respawn-pane", "-k", "-t", pagerPane,
			"env", `PATH=${env.PATH ?? "/usr/bin:/bin"}`,
			"LESS=", "LESSOPEN=", "LESSCLOSE=", "LESSSECURE=1", "LESSHISTFILE=-",
			"less", "-R", "+G", path,
		], env);
		if (started.error || started.status !== 0) {
			throw new Error(started.error?.message || started.stderr?.trim() || "Could not start pager");
		}
		return close;
	} catch (error) {
		close();
		options.onWarning(`Could not render the conversation; opening the editor alone: ${error instanceof Error ? error.message : String(error)}`);
		return () => {};
	}
}

export async function editPrompt(options: EditorOptions): Promise<string | null> {
	const env = options.env ?? process.env;
	const directory = mkdtempSync(join(tmpdir(), "pi-prompt-context-"));
	const promptPath = join(directory, "prompt.md");
	let closePager = () => {};

	try {
		options.signal.throwIfAborted();
		writeFileSync(promptPath, options.prompt, { mode: 0o600 });
		const transcriptPath = join(directory, "conversation.ansi");
		closePager = openPager(transcriptPath, options, env);

		// Match Pi's externalEditor argument handling. Use a wrapper script for complex commands.
		const [command, ...args] = options.command.split(" ");
		const exitCode = await new Promise<number | null>((resolve, reject) => {
			const child = spawn(command, [...args, promptPath], {
				cwd: options.cwd,
				env,
				stdio: "inherit",
				shell: process.platform === "win32",
				signal: options.signal,
			});
			let spawnError: Error | undefined;
			child.once("error", (error) => {
				spawnError = error;
			});
			// Wait for terminal ownership to end before resuming Pi, including on abort.
			child.once("close", (code) => spawnError ? reject(spawnError) : resolve(code));
		});

		if (exitCode !== 0) {
			options.onWarning("Editor exited without accepting changes; the original draft is unchanged");
			return null;
		}
		return readFileSync(promptPath, "utf8").replace(/^\uFEFF/, "").replace(/\n$/, "");
	} finally {
		closePager();
		rmSync(directory, { recursive: true, force: true });
	}
}
