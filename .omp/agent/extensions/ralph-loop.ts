/**
 * Ralph Loop Extension for Oh My Pi
 * 
 * Implements iterative subagent execution loops until completion criteria met.
 * Uses omp's built-in task agents for parallel/sequential work.
 */

import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { spawn } from "node:child_process";
import { writeFile, readFile, unlink } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";

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

let currentLoop: LoopState | null = null;

const RalphLoopSchema = Type.Object({
	prompt: Type.String({
		description: "Task description for the subagent to execute each iteration",
	}),
	agent: Type.Optional(
		Type.String({
			description: "Agent type to use (task, explore, plan, etc.). Default: task",
			default: "task",
		}),
	),
	conditionCommand: Type.Optional(
		Type.String({
			description: "Shell command that must output 'true' to continue loop. If omitted, runs until maxIterations.",
		}),
	),
	maxIterations: Type.Optional(
		Type.Number({
			description: "Maximum number of iterations. Default: 10",
			default: 10,
			minimum: 1,
		}),
	),
	model: Type.Optional(
		Type.String({
			description: "Model to use for subagent tasks",
		}),
	),
	thinking: Type.Optional(
		Type.String({
			description: "Thinking level: minimal, low, medium, high, xhigh",
		}),
	),
	sleepMs: Type.Optional(
		Type.Number({
			description: "Minimum delay between iterations in milliseconds. Default: 0",
			default: 0,
			minimum: 0,
		}),
	),
});

type RalphLoopParams = {
	prompt: string;
	agent?: string;
	conditionCommand?: string;
	maxIterations?: number;
	model?: string;
	thinking?: string;
	sleepMs?: number;
};

async function sleep(ms: number): Promise<void> {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

async function checkCondition(command: string): Promise<boolean> {
	return new Promise((resolve) => {
		const proc = spawn("bash", ["-c", command], {
			stdio: ["ignore", "pipe", "pipe"],
		});

		let stdout = "";
		proc.stdout?.on("data", (data) => {
			stdout += data.toString();
		});

		proc.on("close", () => {
			resolve(stdout.trim().toLowerCase() === "true");
		});

		proc.on("error", () => {
			resolve(false);
		});

		// Timeout after 5 seconds
		setTimeout(() => {
			proc.kill();
			resolve(false);
		}, 5000);
	});
}

async function runSubagent(
	params: RalphLoopParams,
	iteration: number,
	steering: string[],
	followUps: string[],
): Promise<{ exitCode: number; output: string }> {
	const agent = params.agent || "task";
	const tmpFile = join(tmpdir(), `ralph-loop-${Date.now()}-${iteration}.md`);

	// Build prompt with steering/follow-ups
	let fullPrompt = params.prompt;
	if (steering.length > 0) {
		fullPrompt += "\n\n## Steering Instructions\n" + steering.join("\n");
	}
	if (followUps.length > 0) {
		fullPrompt += "\n\n## Follow-up Tasks\n" + followUps.join("\n");
	}

	await writeFile(tmpFile, fullPrompt, "utf-8");

	return new Promise((resolve) => {
		const args = ["--no-session", "-p"];

		if (params.model) {
			args.push("--model", params.model);
		}

		if (params.thinking) {
			args.push("--thinking", params.thinking);
		}

		// Add agent context
		args.push(`@${tmpFile}`);

		const proc = spawn("omp", args, {
			stdio: ["ignore", "pipe", "pipe"],
			env: {
				...process.env,
				OMP_AGENT: agent,
			},
		});

		let output = "";
		let stderr = "";

		proc.stdout?.on("data", (data) => {
			output += data.toString();
		});

		proc.stderr?.on("data", (data) => {
			stderr += data.toString();
		});

		proc.on("close", async (code) => {
			// Clean up temp file
			try {
				await unlink(tmpFile);
			} catch {
				// Ignore cleanup errors
			}

			resolve({
				exitCode: code ?? 1,
				output: output || stderr,
			});
		});

		proc.on("error", async (err) => {
			try {
				await unlink(tmpFile);
			} catch {
				// Ignore
			}

			resolve({
				exitCode: 1,
				output: `Failed to spawn subagent: ${err.message}`,
			});
		});
	});
}

export default function ralphLoopExtension(pi: ExtensionAPI) {
	pi.setLabel("Ralph Loop");

	// Register the ralph_loop tool
	pi.registerTool({
		name: "ralph_loop",
		label: "Ralph Loop",
		description: "Execute a task in a loop using subagents until completion criteria met",
		parameters: RalphLoopSchema,
		execute: async (_toolCallId, params: RalphLoopParams) => {
			const runId = Date.now().toString(36);
			const maxIter = params.maxIterations ?? 10;
			const sleepMs = params.sleepMs ?? 0;

			currentLoop = {
				runId,
				status: "running",
				iteration: 0,
				maxIterations: maxIter,
				conditionCommand: params.conditionCommand,
				prompt: params.prompt,
				agent: params.agent || "task",
				model: params.model,
				thinking: params.thinking,
				sleepMs,
				results: [],
				steering: [],
				followUps: [],
			};

			const output: string[] = [];
			output.push(`🔄 Ralph Loop Started (ID: ${runId})`);
			output.push(`Agent: ${currentLoop.agent}`);
			output.push(`Max Iterations: ${maxIter}`);
			if (params.conditionCommand) {
				output.push(`Condition: ${params.conditionCommand}`);
			}
			if (params.model) {
				output.push(`Model: ${params.model}`);
			}
			output.push("");

			let shouldContinue = true;
			let stopReason = "unknown";

			while (shouldContinue && currentLoop.iteration < maxIter) {
				currentLoop.iteration++;

				// Check if paused
				while (currentLoop.status === "paused") {
					await sleep(500);
				}

				// Check if stopped
				if (currentLoop.status === "stopped") {
					stopReason = "manually stopped";
					shouldContinue = false;
					break;
				}

				output.push(`--- Iteration ${currentLoop.iteration} ---`);

				// Collect and clear steering/follow-ups
				const iterSteering = [...currentLoop.steering];
				const iterFollowUps = [...currentLoop.followUps];
				currentLoop.steering = [];
				currentLoop.followUps = [];

				// Run subagent
				const result = await runSubagent(params, currentLoop.iteration, iterSteering, iterFollowUps);

				currentLoop.results.push({
					iteration: currentLoop.iteration,
					exitCode: result.exitCode,
					output: result.output,
					timestamp: Date.now(),
				});

				if (result.exitCode !== 0) {
					output.push(`❌ Subagent failed (exit ${result.exitCode})`);
					output.push(result.output.substring(0, 500));
					stopReason = "subagent failure";
					shouldContinue = false;
					break;
				}

				output.push(`✓ Iteration ${currentLoop.iteration} complete`);

				// Check for completion promise in output
				if (result.output.includes("<promise>") && result.output.includes("</promise>")) {
					const match = result.output.match(/<promise>(.*?)<\/promise>/i);
					if (match) {
						output.push(`🎯 Completion promise detected: ${match[1]}`);
						stopReason = "completion promise";
						shouldContinue = false;
						break;
					}
				}

				// Check condition if provided
				if (params.conditionCommand) {
					const conditionMet = await checkCondition(params.conditionCommand);
					if (!conditionMet) {
						output.push(`⏹ Condition returned false`);
						stopReason = "condition failed";
						shouldContinue = false;
						break;
					}
					output.push(`✓ Condition check passed`);
				}

				// Check max iterations
				if (currentLoop.iteration >= maxIter) {
					stopReason = "max iterations reached";
					shouldContinue = false;
					break;
				}

				// Sleep before next iteration
				if (sleepMs > 0 && shouldContinue) {
					await sleep(sleepMs);
				}

				output.push("");
			}

			output.push("");
			output.push(`🏁 Ralph Loop Completed`);
			output.push(`Stop Reason: ${stopReason}`);
			output.push(`Total Iterations: ${currentLoop.iteration}`);

			const finalState = { ...currentLoop };
			currentLoop = null;

			return {
				content: [{ type: "text" as const, text: output.join("\n") }],
				details: finalState,
			};
		},
	});

	// Register control commands
	pi.registerCommand("ralph-steer", {
		description: "Add steering instructions to the current ralph loop iteration",
		handler: async (args, ctx) => {
			if (!currentLoop || currentLoop.status !== "running") {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			const message = args.join(" ");
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
		handler: async (args, ctx) => {
			if (!currentLoop || currentLoop.status !== "running") {
				ctx.ui.notify("No active ralph loop", "warning");
				return;
			}

			const message = args.join(" ");
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
		handler: async (_args, ctx) => {
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
		handler: async (_args, ctx) => {
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
		handler: async (_args, ctx) => {
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
		handler: async (_args, ctx) => {
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

	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.notify("🔄 Ralph Loop extension loaded", "info");
	});
}
