# Ralph Loop Extension - Setup Guide

## Installation

The ralph loop extension is already created in your omp extensions directory:

- Extension: `~/.omp/extensions/ralph-loop.ts`
- Documentation: `~/.omp/extensions/ralph-loop.md`
- Test script: `~/.omp/extensions/ralph-loop-test.sh`

## Quick Start

### Option 1: Load extension per session

```bash
omp -e ~/.omp/extensions/ralph-loop.ts
```

Then use the `ralph_loop` tool in your conversation:

```
Use the ralph_loop tool to implement a feature with these parameters:
- prompt: "Build a todo API with CRUD operations and tests"
- agent: task
- maxIterations: 15
```

### Option 2: Enable extension globally

If omp supports a settings/config file, add the extension path to auto-load it.

Check your omp settings location:

```bash
# Look for settings file
ls ~/.omp/agent/settings.json
# or
ls ~/.config/omp/settings.json
```

Add to settings:

```json
{
  "extensions": [
    "~/.omp/extensions/ralph-loop.ts"
  ]
}
```

## Verification

### Test the extension is loaded

```bash
omp -e ~/.omp/extensions/ralph-loop.ts --print "List all available tools"
```

You should see `ralph_loop` in the list.

### Test slash commands

```bash
omp -e ~/.omp/extensions/ralph-loop.ts
```

In the session, type:
```
/ralph-status
```

You should see: "No active ralph loop"

### Run the test script

```bash
~/.omp/extensions/ralph-loop-test.sh
```

This shows example commands you can run to test the extension.

## Available Features

### Tool: `ralph_loop`

Execute iterative subagent tasks until completion.

**Parameters:**
- `prompt` (required): Task description
- `agent` (optional): Agent type (default: "task")
- `maxIterations` (optional): Max iterations (default: 10)
- `conditionCommand` (optional): Shell command to check continuation
- `model` (optional): Model to use
- `thinking` (optional): Thinking level
- `sleepMs` (optional): Delay between iterations

### Slash Commands

- `/ralph-steer <message>` - Add steering to current iteration
- `/ralph-follow <message>` - Queue follow-up task
- `/ralph-pause` - Pause the loop
- `/ralph-resume` - Resume the loop
- `/ralph-stop` - Stop the loop
- `/ralph-status` - Show loop status

## Example Usage

### Example 1: TDD Workflow

```
Use ralph_loop to implement user authentication:

Parameters:
- prompt: "Write tests for user registration, login, logout. Then implement each feature until all tests pass. Output <promise>TESTS_PASSING</promise> when done."
- agent: task
- maxIterations: 20
- conditionCommand: "npm test 2>/dev/null && echo true || echo false"
```

### Example 2: Incremental Refactoring

```
Use ralph_loop for code cleanup:

Parameters:
- prompt: "Refactor src/api/ directory. Phase 1: Extract duplicated code. Phase 2: Add type annotations. Phase 3: Update tests. Output <promise>REFACTOR_COMPLETE</promise> when done."
- agent: task
- maxIterations: 15
- sleepMs: 1000
```

### Example 3: Exploration

```
Use ralph_loop to understand the codebase:

Parameters:
- prompt: "Map the architecture of this project. Identify: 1) Main modules, 2) Data flow, 3) External dependencies. Output <promise>ANALYSIS_COMPLETE</promise> when done."
- agent: explore
- maxIterations: 8
```

## How It Works

1. **Spawns subagents**: Each iteration spawns a new omp subagent using the specified agent type
2. **Manages state**: Tracks iteration count, results, and control state
3. **Checks conditions**: Evaluates completion promise or condition command
4. **Interactive control**: Slash commands to steer, pause, resume, or stop
5. **Clean termination**: Stops on completion, max iterations, or failure

## Subagent Types

The extension works with all omp bundled agents:

- **task** - General-purpose implementation (default)
- **explore** - Read-only codebase exploration
- **plan** - Architectural planning
- **reviewer** - Code review
- **librarian** - External library research
- **oracle** - Deep reasoning
- **designer** - UI/UX implementation
- **quick_task** - Fast mechanical updates

## Troubleshooting

### Extension not loading

Check TypeScript syntax:
```bash
cd ~/.omp/extensions
npx tsc --noEmit ralph-loop.ts
```

### Tool not appearing

Verify extension is loaded:
```bash
omp -e ~/.omp/extensions/ralph-loop.ts --print "What tools do you have access to?"
```

### Subagent failures

Check that omp is in PATH:
```bash
which omp
omp --version
```

### Loop won't stop

Use force stop:
```bash
# In the omp session:
/ralph-stop
```

Or kill the process externally if needed.

## Advanced Usage

### Custom Agents

If you have custom agents in `~/.omp/agent/agents/`, you can use them:

```
Parameters:
- agent: my-custom-agent
```

### Combining with Other Extensions

Load multiple extensions:

```bash
omp -e ~/.omp/extensions/ralph-loop.ts -e ~/.omp/extensions/other-ext.ts
```

### Programmatic Control

Extensions can interact with ralph loop state via the event bus or by checking the global `currentLoop` state (though this is implementation-specific).

## Next Steps

1. Read the full documentation: `~/.omp/extensions/ralph-loop.md`
2. Run the test script: `~/.omp/extensions/ralph-loop-test.sh`
3. Try a simple example with your own project
4. Experiment with different agents and completion criteria

## Support

For issues or questions:
- Check the documentation: `~/.omp/extensions/ralph-loop.md`
- Review the source: `~/.omp/extensions/ralph-loop.ts`
- Test with: `~/.omp/extensions/ralph-loop-test.sh`

## Comparison to Other Ralph Implementations

### vs. Claude Code ralph-wiggum

- **Architecture**: Spawns subagents via CLI instead of stop hooks
- **Agents**: Uses omp's multi-agent system (task, explore, plan, etc.)
- **Control**: Same slash command interface
- **Portability**: Works with any omp-compatible setup

### vs. prateekmedia/pi-hooks ralph-loop

- **Simpler**: No complex process management
- **Native subagents**: Uses omp's built-in agent system
- **CLI-based**: Spawns omp processes rather than internal task API

The omp ralph-loop extension focuses on simplicity and leveraging omp's existing subagent capabilities rather than implementing a separate task execution framework.
