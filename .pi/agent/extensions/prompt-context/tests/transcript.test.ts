import assert from "node:assert/strict";
import fs from "node:fs/promises";
import { mock, test } from "node:test";
import { stripVTControlCharacters } from "node:util";
import {
	AssistantMessageComponent, UserMessageComponent, getMarkdownTheme, initTheme, type SessionEntry,
} from "@earendil-works/pi-coding-agent";
import { visibleWidth, type Component, type TUI } from "@earendil-works/pi-tui";
import { formatTranscript } from "../transcript.ts";

initTheme("dark", false);
const options = { width: 80, cwd: "/tmp", ui: { requestRender() {} } as TUI, hideThinking: true };

function message(role: string, content: unknown, extra: Record<string, unknown> = {}): SessionEntry {
	return {
		type: "message", id: "test", parentId: null, timestamp: "2026-01-01T00:00:00Z",
		message: { role, content, timestamp: 0, stopReason: "stop", ...extra },
	} as SessionEntry;
}

function entry(type: string, extra: Record<string, unknown>): SessionEntry {
	return { type, id: "test", parentId: null, timestamp: "2026-01-01T00:00:00Z", ...extra } as SessionEntry;
}

function plain(output: string): string {
	return stripVTControlCharacters(output).split("\n").map((line) => line.trimEnd()).join("\n");
}

function assertNativeStyles(output: string, component: Component, width: number) {
	for (const line of component.render(width)) {
		const withoutPromptMarks = line.replace(/\x1b\]133;[ABC]\x07/g, "");
		assert.ok(output.includes(withoutPromptMarks + "\x1b[0m"), "contains Pi's styled component line");
	}
}

test("uses Pi's native message colours, Markdown, and code highlighting", () => {
	const user = "Review **this code**";
	const assistant = message("assistant", [{ type: "text", text: "## Result\n\n```typescript\nconst answer = 42;\n```" }]);
	const output = formatTranscript([message("user", user), assistant], options);
	assertNativeStyles(output, new UserMessageComponent(user), options.width);
	if (assistant.type !== "message" || assistant.message.role !== "assistant") throw new Error("Invalid test fixture");
	assertNativeStyles(output, new AssistantMessageComponent(assistant.message, true), options.width);
	assert.match(output, /\x1b\[48;/);
	assert.match(output, /\x1b\[38;/);
	assert.doesNotMatch(plain(output), /## Result|\*\*this code\*\*/);
	assert.match(plain(output), /const answer = 42/);
});

test("respects message padding and code-block indentation", () => {
	const assistant = message("assistant", [{ type: "text", text: "```js\nconst value = 1;\n```" }]);
	const settings = { ...options, outputPad: 0 as const, codeBlockIndent: "    " };
	const output = formatTranscript([message("user", "No padding"), assistant], settings);
	const theme = { ...getMarkdownTheme(), codeBlockIndent: settings.codeBlockIndent };
	assertNativeStyles(output, new UserMessageComponent("No padding", theme, 0), options.width);
	if (assistant.type !== "message" || assistant.message.role !== "assistant") throw new Error("Invalid test fixture");
	assertNativeStyles(output, new AssistantMessageComponent(assistant.message, true, theme, undefined, 0), options.width);
});

test("renders chronological tool calls with expanded recorded output", () => {
	const output = plain(formatTranscript([
		message("user", "First line\nSecond line"),
		message("assistant", [
			{ type: "text", text: "Checking now" },
			{ type: "toolCall", id: "call1", name: "read", arguments: { path: "a b.txt" } },
		]),
		message("toolResult", [{ type: "text", text: "One\nTwo\nThree" }], { toolCallId: "call1", toolName: "read", isError: true }),
		message("assistant", [{ type: "text", text: "Finished" }]),
	], options));
	assert.match(output, /First line/);
	assert.match(output, /read a b.txt/);
	assert.match(output, /One\n +Two\n +Three/);
	assert.ok(output.indexOf("Checking now") < output.indexOf("One"));
	assert.ok(output.trimEnd().endsWith("Finished"));
});

test("pairs parallel results with their calls and preserves orphan results", () => {
	const output = plain(formatTranscript([
		message("assistant", [
			{ type: "toolCall", id: "a", name: "custom-one", arguments: { query: "first" } },
			{ type: "toolCall", id: "b", name: "custom-two", arguments: { query: "second" } },
		]),
		message("toolResult", [{ type: "text", text: "SECOND RESULT" }], { toolCallId: "b", toolName: "custom-two" }),
		message("toolResult", [{ type: "text", text: "FIRST RESULT" }], { toolCallId: "a", toolName: "custom-one" }),
		message("toolResult", [{ type: "text", text: "ORPHAN RESULT" }], { toolCallId: "missing", toolName: "unknown" }),
	], options));
	assert.ok(output.indexOf("FIRST RESULT") < output.indexOf("custom-two"));
	assert.ok(output.indexOf("SECOND RESULT") > output.indexOf("custom-two"));
	assert.equal(output.match(/FIRST RESULT/g)?.length, 1);
	assert.match(output, /ORPHAN RESULT/);
});

test("renders recorded edit diffs without reading current files", async () => {
	const read = mock.method(fs, "readFile", async () => { throw new Error("Rendering must not read files"); });
	try {
		const output = formatTranscript([
			message("assistant", [{ type: "toolCall", id: "edit1", name: "edit", arguments: {
				path: "history.ts", edits: [{ oldText: "oldValue", newText: "newValue" }],
			} }]),
			message("toolResult", [{ type: "text", text: "Successfully edited" }], {
				toolCallId: "edit1", toolName: "edit", isError: false,
				details: { diff: "-1 const oldValue = 1;\n+1 const newValue = 2;", firstChangedLine: 1 },
			}),
		], options);
		assert.match(plain(output), /oldValue/);
		assert.match(plain(output), /newValue/);
		assert.match(output, /\x1b\[38;/);
		await new Promise((resolve) => setImmediate(resolve));
		assert.equal(read.mock.callCount(), 0);
	} finally {
		read.mock.restore();
	}
});

test("hides thinking and replaces images without leaking replay signatures", () => {
	const branch = [message("assistant", [
		{ type: "thinking", thinking: "Private reasoning", thinkingSignature: "opaque-secret" },
		{ type: "thinking", thinking: "", redacted: true, thinkingSignature: "encrypted-secret" },
		{ type: "text", text: "Visible answer" },
		{ type: "image", mimeType: "image/png", data: "BASE64_PAYLOAD" },
	])];
	const hidden = plain(formatTranscript(branch, options));
	assert.doesNotMatch(hidden, /Private reasoning|opaque-secret|encrypted-secret|BASE64_PAYLOAD/);
	assert.match(hidden, /Visible answer/);
	assert.match(hidden, /\[Image: image\/png\]/);
	const shown = plain(formatTranscript(branch, { ...options, hideThinking: false }));
	assert.match(shown, /Private reasoning/);
	assert.match(shown, /\[Redacted\]/);
	assert.doesNotMatch(shown, /opaque-secret|encrypted-secret|BASE64_PAYLOAD/);
});

test("shows expanded compaction and branch summaries without removing older history", () => {
	const output = plain(formatTranscript([
		message("user", "Older message"),
		entry("compaction", { summary: "Compacted work", firstKeptEntryId: "test", tokensBefore: 100 }),
		entry("branch_summary", { summary: "Other branch summary", fromId: "old" }),
		message("user", "Current branch message"),
	], options));
	assert.match(output, /not the exact model context/);
	assert.match(output, /Older message/);
	assert.match(output, /Compacted work/);
	assert.match(output, /Other branch summary/);
	assert.ok(output.trimEnd().endsWith("Current branch message"));
});

test("omits system prompts and hidden extension state", () => {
	const output = plain(formatTranscript([
		message("system", "System instructions"),
		entry("custom", { customType: "state", data: "Stored state" }),
		entry("custom_message", { customType: "hidden", content: "Hidden entry", display: false }),
		message("custom", "Hidden message", { customType: "hidden", display: false }),
		entry("custom_message", { customType: "notice", content: "Visible entry", display: true }),
		message("custom", "Visible message", { customType: "notice", display: true }),
	], options));
	assert.doesNotMatch(output, /System instructions|Stored state|Hidden entry|Hidden message/);
	assert.match(output, /Visible entry/);
	assert.match(output, /Visible message/);
});

test("renders completed shell commands and assistant errors", () => {
	const output = plain(formatTranscript([
		message("bashExecution", undefined, {
			command: "printf hello", output: "hello", exitCode: 1,
			cancelled: true, truncated: true, excludeFromContext: true,
		}),
		message("assistant", [], { stopReason: "error", errorMessage: "Request failed" }),
	], options));
	assert.match(output, /\$ printf hello/);
	assert.match(output, /hello/);
	assert.match(output, /cancelled/);
	assert.match(output, /Request failed/);
	assert.doesNotMatch(output, /Running/);
});

test("sanitizes raw content and permits only renderer-generated SGR escapes", () => {
	const output = formatTranscript([
		message("user", "\x1b[5mInjected\x1b[0m\r\nLine\tTwo\x00\x07\x1b]52;c;secret\x07"),
		message("assistant", [{ type: "text", text: "[Website](https://example.com)\n\x1b[2JAnswer" }]),
		message("assistant", [{ type: "toolCall", id: "unsafe", name: "custom", arguments: { text: "\x1b[5mTool\x1b[0m" } }]),
		message("toolResult", [{ type: "text", text: "\x1b]0;evil-title\x07Output" }], { toolCallId: "unsafe", toolName: "custom" }),
	], options);
	assert.match(plain(output), /Injected/);
	assert.match(plain(output), /Line +Two/);
	assert.match(plain(output), /Website/);
	assert.doesNotMatch(output, /secret|evil-title|\x1b\[5m|\x1b\[2J|\x1b\]/);
	assert.doesNotMatch(output.replace(/\x1b\[[0-9;:]*m/g, ""), /[\x00-\x08\x0b-\x1f\x7f-\x9f]/);
	assert.ok(output.trimEnd().endsWith("\x1b[0m"));
});

test("wraps Markdown, tables, and wide text to the requested pane width", () => {
	const branch = [message("assistant", [{ type: "text", text: [
		"A long paragraph with repeated words that should wrap to the pane width. ".repeat(3),
		"| Column one | Column two |\n| --- | --- |\n| A long table cell | More content here |",
		"Unicode: 日本語 and café\n\n```typescript\nconst value = 'a long string that needs wrapping';\n```",
	].join("\n\n") }])];
	for (const width of [24, 40, 72]) {
		const output = formatTranscript(branch, { ...options, width });
		for (const line of output.trimEnd().split("\n")) assert.ok(visibleWidth(line) <= width, `line fits width ${width}`);
	}
});

test("uses the active Pi theme without mutating session data", () => {
	const branch = [message("user", "Theme sample")];
	const before = structuredClone(branch);
	const dark = formatTranscript(branch, options);
	try {
		initTheme("light", false);
		const light = formatTranscript(branch, options);
		assert.notEqual(dark, light);
		assertNativeStyles(light, new UserMessageComponent("Theme sample", getMarkdownTheme()), options.width);
		assert.deepEqual(branch, before);
	} finally {
		initTheme("dark", false);
	}
});

test("handles an empty session and rejects unusable pane widths", () => {
	assert.match(plain(formatTranscript([], options)), /No conversation messages yet/);
	assert.throws(() => formatTranscript([], { ...options, width: 0 }), /too narrow/);
});
