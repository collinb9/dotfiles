/// <reference types="node" />
/**
 * Ralph Loop Extension for Oh My Pi
 *
 * Implements iterative subagent execution loops until completion criteria met.
 * Also provides Ralph spec generation as a one-shot subagent workflow.
 */

import { spawn } from "node:child_process";
import { writeFile, unlink } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";

type ToolExecutionResult = {
	content: Array<{ type: "text"; text: string }>;
	details?: unknown;
};

interface ExtensionAPI {
	setLabel(label: string): void;
	registerTool(definition: {
		name: string;
		label: string;
		description: string;
		parameters: unknown;
		execute: (toolCallId: string, params: any) => Promise<ToolExecutionResult> | ToolExecutionResult;
	}): void;
	registerCommand(
		name: string,
		definition: {
			description: string;
			handler: (args: string, ctx: CommandContext) => Promise<void> | void;
		},
	): void;
	on(
		event: string,
		handler: (event: unknown, ctx: CommandContext) => Promise<void> | void,
	): void;
}

interface LoopState {
	runId: string;
	status: "idle" | "running" | "paused" | "stopped";
	iteration: number;
	maxIterations: number;
	conditionCommand?: string;
	prompt: string;
	agent: string;
	model?: string;
	thinking?: string;
	sleepMs: number;
	results: Array<{
		iteration: number;
		exitCode: number;
		output: string;
		timestamp: number;
	}>;
	steering: string[];
	followUps: string[];
}

interface OmpRunParams {
	prompt: string;
	agent?: string;
	model?: string;
	thinking?: string;
}

interface OmpRunResult {
	exitCode: number;
	output: string;
}

interface RalphLoopParams {
	prompt: string;
	agent?: string;
	conditionCommand?: string;
	maxIterations?: number;
	model?: string;
	thinking?: string;
	sleepMs?: number;
}

interface RalphSpecParams {
	prompt: string;
	model?: string;
	thinking?: string;
}

type NotificationLevel = "info" | "warning" | "error";

interface CommandContext {
	ui: {
		notify(message: string, level?: NotificationLevel): void;
	};
}

let currentLoop: LoopState | null = null;

const RalphLoopSchema = {
	type: "object",
	properties: {
		prompt: {
			type: "string",
			description: "Task description for the subagent to execute each iteration",
		},
		agent: {
			type: "string",
			description: "Agent type to use (task, explore, plan, etc.). Default: task",
			default: "task",
		},
		conditionCommand: {
			type: "string",
			description: "Shell command that must output 'true' to continue loop. If omitted, runs until maxIterations.",
		},
		maxIterations: {
			type: "number",
			description: "Maximum number of iterations. Default: 10",
			default: 10,
			minimum: 1,
		},
		model: {
			type: "string",
			description: "Model to use for subagent tasks",
		},
		thinking: {
			type: "string",
			description: "Thinking level: minimal, low, medium, high, xhigh",
		},
		sleepMs: {
			type: "number",
			description: "Minimum delay between iterations in milliseconds. Default: 0",
			default: 0,
			minimum: 0,
		},
	},
	required: ["prompt"],
} as const;

const RalphSpecSchema = {
	type: "object",
	properties: {
		prompt: {
			type: "string",
			description: "JTBD or feature description to turn into one or more Ralph spec files",
		},
		model: {
			type: "string",
			description: "Model to use for spec generation",
		},
		thinking: {
			type: "string",
			description: "Thinking level: minimal, low, medium, high, xhigh",
		},
	},
	required: ["prompt"],
} as const;

const RALPH_SPEC_RULES = `
You are generating Ralph spec files for the user's current workspace.

Core rules:
- Start from the user's real job-to-be-done, not an implementation idea.
- Decompose the goal into distinct topics of concern. If one sentence needs "and" to join unrelated capabilities, split it.
- Create one spec file per topic of concern.
- Keep each task atomic. If a task needs "and" to describe it, split it.
- Order topics and tasks by dependency and importance.
- Spec files live in specs/{number}-{topic}.md, numbered in priority order.
- Specs must be understandable by a fresh agent with no prior context.
- Acceptance criteria must describe observable behavior and outcomes, not implementation details.
- Do not prescribe algorithms, data structures, libraries, or code patterns unless the user explicitly requires them.
- Do not use code blocks or example code in the spec content.
- Use the review tag to signal readiness: <review></review> means ready.

Required file format:
---
title: "Topic Name"
created: YYYY-MM-DD
iteration: 1
---
<project_specification>
  <project_name>Topic Name</project_name>
  <overview>
    2-4 sentences explaining the outcome.
  </overview>
  <context>
    Background, constraints, and integration points relevant to the topic.
  </context>
  <tasks>
    <task id="task-id" priority="1" category="functional">
      <title>Task Title</title>
      <description>What to accomplish</description>
      <acceptance_criteria>
        - Observable outcome 1
        - Observable outcome 2
      </acceptance_criteria>
      <review></review>
    </task>
  </tasks>
</project_specification>

Use optional sections only when relevant: technology_stack, database_schema, api_endpoints_summary.
Write the spec files into the current workspace instead of only describing them.
`.trim();

function buildLoopPrompt(params: RalphLoopParams, steering: string[], followUps: string[]): string {
	let fullPrompt = params.prompt;

	if (steering.length > 0) {
		fullPrompt += "\n\n## Steering Instructions\n" + steering.join("\n");
	}

	if (followUps.length > 0) {
		fullPrompt += "\n\n## Follow-up Tasks\n" + followUps.join("\n");
	}

	return fullPrompt;
}

function buildSpecPrompt(prompt: string): string {
	return [
		"You are a Ralph spec generator operating inside the user's workspace.",
		"Turn the request into well-scoped spec files that another agent can implement without prior context.",
		"",
		"User request:",
		prompt,
		"",
		"Rules:",
		RALPH_SPEC_RULES,
	].join("\n");
}

function combineOutput(stdout: string, stderr: string): string {
	const parts = [stdout.trim(), stderr.trim()].filter(Boolean);
	return parts.join("\n");
}

async function sleep(ms: number): Promise<void> {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

async function checkCondition(command: string): Promise<boolean> {
	return new Promise((resolve) => {
		const proc = spawn("bash", ["-c", command], {
			stdio: ["ignore", "pipe", "pipe"],
		});

		let stdout = "";
		proc.stdout?.on("data", (data: Uint8Array) => {
			stdout += data.toString();
		});

		proc.on("close", () => {
			resolve(stdout.trim().toLowerCase() === "true");
		});

		proc.on("error", () => {
			resolve(false);
		});

		setTimeout(() => {
			proc.kill();
			resolve(false);
		}, 5000);
	});
}

async function runOmpAgent(params: OmpRunParams): Promise<OmpRunResult> {
	const tmpFile = join(
		tmpdir(),
		`ralph-loop-${Date.now()}-${Math.random().toString(36).slice(2)}.md`,
	);

	try {
		await writeFile(tmpFile, params.prompt, "utf-8");
	} catch (error) {
		const message = error instanceof Error ? error.message : String(error);
		return {
			exitCode: 1,
			output: `Failed to write prompt file: ${message}`,
		};
	}

	return new Promise((resolve) => {
		const args = ["--no-session", "-p"];

		if (params.model) {
			args.push("--model", params.model);
		}

		if (params.thinking) {
			args.push("--thinking", params.thinking);
		}

		args.push(`@${tmpFile}`);

		const proc = spawn("omp", args, {
			cwd: process.cwd(),
			stdio: ["ignore", "pipe", "pipe"],
			env: {
				...process.env,
				OMP_AGENT: params.agent || "task",
			},
		});

		let stdout = "";
		let stderr = "";

		proc.stdout?.on("data", (data: Uint8Array) => {
			stdout += data.toString();
		});

		proc.stderr?.on("data", (data: Uint8Array) => {
			stderr += data.toString();
		});

		const cleanup = async () => {
			try {
				await unlink(tmpFile);
			} catch {
				// Ignore cleanup errors.
			}
		};

		proc.on("close", async (code: number | null) => {
			await cleanup();
			resolve({
				exitCode: code ?? 1,
				output: combineOutput(stdout, stderr),
			});
		});

		proc.on("error", async (err: Error) => {
			await cleanup();
			resolve({
				exitCode: 1,
				output: `Failed to spawn omp: ${err.message}`,
			});
		});
	});
}

async function runSubagent(
	params: RalphLoopParams,
	steering: string[],
	followUps: string[],
): Promise<OmpRunResult> {
	const prompt = buildLoopPrompt(params, steering, followUps);

	return runOmpAgent({
		prompt,
		agent: params.agent || "task",
		model: params.model,
		thinking: params.thinking,
	});
}

async function runSpecAgent(params: RalphSpecParams): Promise<OmpRunResult> {
	return runOmpAgent({
		prompt: buildSpecPrompt(params.prompt),
		agent: "task",
		model: params.model,
		thinking: params.thinking,
	});
}

export default function ralphLoopExtension(pi: ExtensionAPI) {
	pi.setLabel("Ralph Loop");

	pi.registerCommand("ralph-spec", {
		description: "Generate Ralph spec files from a JTBD prompt",
		handler: async (args: string, ctx: CommandContext) => {
			const prompt = args.trim();
			if (!prompt) {
				ctx.ui.notify("Usage: /ralph-spec <prompt>", "warning");
				return;
			}

			const result = await runSpecAgent({ prompt });
			ctx.ui.notify(
				result.output || (result.exitCode === 0 ? "Spec generation completed" : "Spec generation failed"),
				result.exitCode === 0 ? "info" : "error",
			);
		},
	});

	pi.registerCommand("ralph-steer", {
		description: "Add steering instructions to the current ralph loop iteration",
		handler: async (args: string, ctx: CommandContext) => {
			if (!currentLoop || currentLoop.status !== "running") {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			const message = args.trim();
			if (!message) {
				ctx.ui.notify("Usage: /ralph-steer <message>", "warning");
				return;
			}

			currentLoop.steering.push(message);
			ctx.ui.notify(`Steering queued: ${message}`, "info");
		},
	});

	pi.registerCommand("ralph-follow", {
		description: "Queue a follow-up task for the next ralph loop iteration",
		handler: async (args: string, ctx: CommandContext) => {
			if (!currentLoop || currentLoop.status !== "running") {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			const message = args.trim();
			if (!message) {
				ctx.ui.notify("Usage: /ralph-follow <message>", "warning");
				return;
			}

			currentLoop.followUps.push(message);
			ctx.ui.notify(`Follow-up queued: ${message}`, "info");
		},
	});

	pi.registerCommand("ralph-pause", {
		description: "Pause the current ralph loop",
		handler: async (_args: string, ctx: CommandContext) => {
			if (!currentLoop) {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			if (currentLoop.status === "paused") {
				ctx.ui.notify("Ralph loop is already paused", "info");
				return;
			}

			currentLoop.status = "paused";
			ctx.ui.notify(`Ralph loop paused at iteration ${currentLoop.iteration}`, "info");
		},
	});

	pi.registerCommand("ralph-resume", {
		description: "Resume a paused ralph loop",
		handler: async (_args: string, ctx: CommandContext) => {
			if (!currentLoop) {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			if (currentLoop.status !== "paused") {
				ctx.ui.notify("Ralph loop is not paused", "info");
				return;
			}

			currentLoop.status = "running";
			ctx.ui.notify("Ralph loop resumed", "info");
		},
	});

	pi.registerCommand("ralph-stop", {
		description: "Stop the current ralph loop",
		handler: async (_args: string, ctx: CommandContext) => {
			if (!currentLoop) {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			currentLoop.status = "stopped";
			ctx.ui.notify(`Ralph loop will stop after iteration ${currentLoop.iteration}`, "info");
		},
	});

	pi.registerCommand("ralph-status", {
		description: "Show ralph loop status",
		handler: async (_args: string, ctx: CommandContext) => {
			if (!currentLoop) {
				ctx.ui.notify("No active ralph loop", "info");
				return;
			}

			const lines = [
				`Ralph Loop Status:`,
				`  ID: ${currentLoop.runId}`,
				`  Status: ${currentLoop.status}`,
				`  Iteration: ${currentLoop.iteration} / ${currentLoop.maxIterations}`,
				`  Agent: ${currentLoop.agent}`,
				`  Steering queued: ${currentLoop.steering.length}`,
				`  Follow-ups queued: ${currentLoop.followUps.length}`,
			];

			if (currentLoop.results.length > 0) {
				const lastResult = currentLoop.results[currentLoop.results.length - 1];
				lines.push(`  Last result: ${lastResult.exitCode === 0 ? "success" : "failure"}`);
			}

			ctx.ui.notify(lines.join("\n"), "info");
		},
	});

	pi.on("session_start", async (_event: unknown, ctx: CommandContext) => {
		ctx.ui.notify("🔄 Ralph Loop extension loaded", "info");
	});
}
