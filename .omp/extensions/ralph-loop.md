# Ralph Loop Extension for Oh My Pi

Implements the Ralph Wiggum technique for iterative, self-referential AI development loops using omp's built-in subagent system.

## What is Ralph Loop?

Ralph Loop is a development methodology based on continuous AI agent loops. The agent repeatedly executes a task, checking its work, and iterating until completion criteria are met.

This implementation uses omp's existing subagent capabilities (`task`, `explore`, `plan`, etc.) to execute work in each iteration.

## Installation

The extension is already installed at `~/.omp/extensions/ralph-loop.ts`.

To enable it, add it to your omp configuration or load it with:

```bash
omp -e ~/.omp/extensions/ralph-loop.ts
```

Or add to your settings permanently (if you have a settings file).

## Usage

### Basic Example

```
Use the ralph_loop tool to build a REST API for todos. Requirements:
- CRUD operations
- Input validation
- Tests passing
- Output <promise>COMPLETE</promise> when done

Parameters:
- prompt: "Build REST API with CRUD, validation, tests. Output <promise>COMPLETE</promise> when all tests pass."
- maxIterations: 20
- agent: task
```

### Tool Parameters

```typescript
{
  prompt: string;              // Task for subagent to execute each iteration (required)
  agent?: string;              // Agent type: task, explore, plan, etc. (default: task)
  conditionCommand?: string;   // Shell command that must output "true" to continue
  maxIterations?: number;      // Max iterations (default: 10)
  model?: string;              // Model to use for subagents
  thinking?: string;           // Thinking level: minimal, low, medium, high, xhigh
  sleepMs?: number;            // Delay between iterations in ms (default: 0)
}
```

## Interactive Controls

While a ralph loop is running, you can use these slash commands:

### `/ralph-steer <message>`
Add steering instructions for the current/next iteration.

```
/ralph-steer Focus on fixing the failing authentication tests first
```

### `/ralph-follow <message>`
Queue a follow-up task for the next iteration.

```
/ralph-follow After tests pass, add API documentation
```

### `/ralph-pause`
Pause the loop after the current iteration completes.

### `/ralph-resume`
Resume a paused loop.

### `/ralph-stop`
Stop the loop gracefully after the current iteration.

### `/ralph-status`
Show current loop status, iteration count, and queued messages.

## Completion Criteria

The loop stops when any of these conditions are met:

1. **Completion Promise**: Output contains `<promise>TEXT</promise>`
   ```
   Output <promise>COMPLETE</promise> when done
   ```

2. **Condition Command**: Shell command returns "true"
   ```typescript
   {
     conditionCommand: "npm test && echo true || echo false"
   }
   ```

3. **Max Iterations**: Reached the iteration limit

4. **Manual Stop**: User executes `/ralph-stop`

5. **Subagent Failure**: Subagent exits with non-zero code

## Examples

### Example 1: Test-Driven Development

```
Use ralph_loop with these parameters:
- prompt: "Implement user authentication. Write tests first, then implement until all tests pass. Output <promise>DONE</promise> when complete."
- agent: task
- maxIterations: 15
- conditionCommand: "npm test 2>/dev/null && echo true || echo false"
```

The loop will:
1. Write tests
2. Implement features
3. Run tests each iteration
4. Fix failures
5. Continue until tests pass or max iterations

### Example 2: Incremental Feature Development

```
Use ralph_loop to implement a shopping cart feature in phases:
- prompt: "Phase 1: Add product to cart. Phase 2: Update quantities. Phase 3: Remove items. Phase 4: Calculate totals. Output <promise>ALL_PHASES_COMPLETE</promise> when done."
- agent: task
- maxIterations: 25
- sleepMs: 2000
```

### Example 3: Exploration with Follow-ups

```
Use ralph_loop to explore the codebase architecture:
- prompt: "Analyze the project structure and identify the main modules"
- agent: explore
- maxIterations: 5
```

Then while running:
```
/ralph-follow Document the data flow between modules
/ralph-follow Identify potential refactoring opportunities
```

## Best Practices

### 1. Clear Completion Criteria

❌ **Bad**: "Make the code better"

✅ **Good**: "Refactor authentication module. Requirements: extract helper functions, add type safety, tests pass. Output <promise>COMPLETE</promise> when done."

### 2. Incremental Goals

Break large tasks into phases that can be verified each iteration.

### 3. Use Appropriate Agents

- `task` - General implementation work
- `explore` - Codebase investigation
- `plan` - Architectural decisions
- `reviewer` - Code review iterations

### 4. Set Iteration Limits

Always set `maxIterations` to prevent infinite loops:

```typescript
{
  maxIterations: 20  // Reasonable safety limit
}
```

### 5. Leverage Condition Commands

Use test suites or linters as exit conditions:

```typescript
{
  conditionCommand: "npm run lint && npm test && echo true"
}
```

## When to Use Ralph Loop

**Good for:**
- Test-driven development workflows
- Iterative bug fixing
- Multi-phase feature implementation
- Code quality improvements with automated checks
- Exploratory refactoring

**Not good for:**
- One-shot operations
- Tasks requiring human judgment
- Unclear success criteria
- Simple single-file edits

## Troubleshooting

### Loop won't stop

- Ensure completion promise is exact: `<promise>COMPLETE</promise>`
- Check condition command returns "true" (lowercase)
- Use `/ralph-stop` to force stop

### Subagent failures

- Check iteration output for errors
- Verify model and thinking level are appropriate
- Reduce scope of each iteration's work

### Performance

- Increase `sleepMs` to reduce API rate limit issues
- Lower `maxIterations` for focused tasks
- Use lighter models for simple iterations

## Architecture

The extension:

1. Spawns omp subagents via CLI (`omp --no-session -p`)
2. Manages iteration state and control flow
3. Injects steering/follow-ups into subsequent iterations
4. Monitors for completion signals and conditions
5. Provides interactive controls via slash commands

Each iteration runs as an independent omp session with the configured agent type, allowing full access to all tools (read, write, edit, bash, grep, etc.).

## License

MIT
