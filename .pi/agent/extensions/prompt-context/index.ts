import { SettingsManager, type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";
import { editPrompt } from "./editor.ts";
import { formatTranscript } from "./transcript.ts";

export default function promptContextExtension(pi: ExtensionAPI) {
	let activeEditor: { controller: AbortController; task: Promise<void> } | undefined;

	async function runEditor(ctx: ExtensionContext, controller: AbortController): Promise<void> {
		const original = ctx.ui.getEditorText();
		const warnings: string[] = [];

		try {
			const settings = SettingsManager.create(ctx.cwd, undefined, { projectTrusted: ctx.isProjectTrusted() });
			const branch = ctx.sessionManager.getBranch();
			const edited = await ctx.ui.custom<string | null>(async (tui, _theme, _keybindings, done) => {
				tui.stop();
				try {
					const text = await editPrompt({
						cwd: ctx.cwd,
						command: settings.getExternalEditorCommand(),
						prompt: original,
						renderTranscript: (width) => formatTranscript(branch, {
							width, cwd: ctx.cwd, ui: tui,
							hideThinking: settings.getHideThinkingBlock(),
							outputPad: settings.getOutputPad(),
							codeBlockIndent: settings.getCodeBlockIndent(),
						}),
						signal: controller.signal,
						onWarning: (message) => warnings.push(message),
					});
					done(text);
				} finally {
					tui.start();
					tui.requestRender(true);
				}
				return { render: () => [], invalidate: () => {} };
			});

			if (!controller.signal.aborted) ctx.ui.setEditorText(edited ?? original);
		} catch (error) {
			if (!controller.signal.aborted) {
				ctx.ui.setEditorText(original);
				ctx.ui.notify(`Could not edit prompt: ${error instanceof Error ? error.message : String(error)}`, "error");
			}
		} finally {
			if (!controller.signal.aborted) {
				for (const warning of warnings) ctx.ui.notify(warning, "warning");
			}
		}
	}

	async function openPromptContext(ctx: ExtensionContext): Promise<void> {
		if (ctx.mode !== "tui") {
			ctx.ui.notify("Prompt editing requires interactive TUI mode", "error");
			return;
		}
		if (activeEditor) return;

		const controller = new AbortController();
		const task = runEditor(ctx, controller).finally(() => {
			activeEditor = undefined;
		});
		activeEditor = { controller, task };
		await task;
	}

	pi.registerCommand("prompt-context", {
		description: "Edit the prompt beside a conversation pager",
		handler: (_args, ctx) => openPromptContext(ctx),
	});
	pi.registerShortcut("ctrl+g", {
		description: "Edit the prompt beside a conversation pager",
		handler: openPromptContext,
	});
	pi.on("session_shutdown", async () => {
		const editor = activeEditor;
		editor?.controller.abort();
		await editor?.task;
	});
}
