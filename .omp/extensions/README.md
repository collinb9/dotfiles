# Ralph Loop Extension - Installation Complete ✓

## 📦 What Was Created

Your ralph loop extension for omp is ready to use! Here's what was installed:

### Core Files
- **Extension**: `~/.omp/extensions/ralph-loop.ts` (11 KB)
  - Main extension implementing the `ralph_loop` tool
  - Slash commands for interactive control
  - Subagent spawning and management

- **Documentation**: `~/.omp/extensions/ralph-loop.md` (6 KB)
  - Complete usage guide
  - Examples and best practices
  - Troubleshooting

- **Setup Guide**: `~/.omp/extensions/RALPH_LOOP_SETUP.md` (6 KB)
  - Installation instructions
  - Configuration options
  - Quick start examples

### Utilities
- **Test Script**: `~/.omp/extensions/ralph-loop-test.sh` (executable)
  - Test scenarios and examples
  - Verification steps

- **Demo Script**: `~/.omp/extensions/ralph-loop-demo.sh` (executable)
  - Working demonstration
  - Simple counter example

- **Package Config**: `~/.omp/extensions/package.json`
  - Extension metadata
  - npm scripts for demo/test

## ✅ Verification

The extension loaded successfully! It's confirmed working:

```bash
$ omp -e ~/.omp/extensions/ralph-loop.ts --print "List tools"
```

Output shows: ✓ `ralph_loop` tool is available

## 🚀 Quick Start

### Option 1: One-time use

```bash
omp -e ~/.omp/extensions/ralph-loop.ts
```

Then in your conversation:
```
Use ralph_loop to build a TODO API:
- prompt: "Create CRUD endpoints with tests. Output <promise>DONE</promise> when complete."
- agent: task
- maxIterations: 15
```

### Option 2: Run the demo

```bash
~/.omp/extensions/ralph-loop-demo.sh
```

This runs a simple counter demonstration showing ralph loop in action.

### Option 3: Enable globally

Add to your omp settings (if you have `~/.omp/agent/settings.json`):

```json
{
  "extensions": [
    "~/.omp/extensions/ralph-loop.ts"
  ]
}
```

## 🎯 Key Features

### Ralph Loop Tool
Execute iterative subagent tasks with completion criteria:

```typescript
{
  prompt: string;              // Task for each iteration
  agent?: string;              // task, explore, plan, etc.
  maxIterations?: number;      // Safety limit (default: 10)
  conditionCommand?: string;   // Shell command to check continuation
  model?: string;              // Override model
  thinking?: string;           // Thinking level
  sleepMs?: number;            // Delay between iterations
}
```

### Slash Commands
- `/ralph-status` - Show loop state
- `/ralph-steer <msg>` - Add steering instructions
- `/ralph-follow <msg>` - Queue follow-up task
- `/ralph-pause` - Pause after current iteration
- `/ralph-resume` - Resume paused loop
- `/ralph-stop` - Stop gracefully

### Completion Criteria
Loop stops when:
1. Output contains `<promise>TEXT</promise>`
2. Condition command returns "true"
3. Max iterations reached
4. Manual stop via `/ralph-stop`
5. Subagent failure

## 📚 Examples

### Example 1: Test-Driven Development
```
Use ralph_loop:
- prompt: "Implement authentication. Write tests, then code until all pass."
- conditionCommand: "npm test && echo true"
- maxIterations: 20
```

### Example 2: Multi-Phase Feature
```
Use ralph_loop:
- prompt: "Phase 1: Database schema. Phase 2: API endpoints. Phase 3: Tests. Output <promise>COMPLETE</promise> when done."
- agent: task
- maxIterations: 25
```

### Example 3: Codebase Exploration
```
Use ralph_loop:
- prompt: "Map project architecture and document findings."
- agent: explore
- maxIterations: 10
```

## 🔧 How It Works

1. **Spawns subagents**: Each iteration runs a new omp subagent
2. **Uses existing agents**: Leverages omp's task, explore, plan, etc.
3. **Manages state**: Tracks iterations, results, control flow
4. **Interactive control**: Pause, resume, steer mid-flight
5. **Clean termination**: Stops on completion or failure

## 📖 Documentation

- Full docs: `~/.omp/extensions/ralph-loop.md`
- Setup guide: `~/.omp/extensions/RALPH_LOOP_SETUP.md`
- Source code: `~/.omp/extensions/ralph-loop.ts`

## 🧪 Testing

Run the test script to see examples:
```bash
~/.omp/extensions/ralph-loop-test.sh
```

Run the demo:
```bash
~/.omp/extensions/ralph-loop-demo.sh
```

## 🎓 Next Steps

1. **Read the docs**: Check `ralph-loop.md` for detailed usage
2. **Run the demo**: Execute `ralph-loop-demo.sh` to see it in action
3. **Try a real task**: Use ralph_loop on your own project
4. **Experiment**: Try different agents and completion criteria

## 💡 Tips

- Always set `maxIterations` to prevent infinite loops
- Use completion promises for clear exit criteria
- Leverage condition commands for test-driven workflows
- Choose the right agent for the job (task vs explore vs plan)
- Use `/ralph-steer` to guide iterations mid-flight

## 🆚 Comparison

This implementation:
- ✓ Uses omp's native subagent system
- ✓ Works with all bundled agents (task, explore, plan, etc.)
- ✓ Simple CLI-based spawning
- ✓ Interactive control commands
- ✓ No external dependencies

vs. other ralph implementations:
- Claude Code ralph-wiggum: Stop-hook based, Claude-specific
- pi-hooks ralph-loop: Complex task API, Pi-specific
- oh-my-ralph: External orchestrator, CLI wrapper

## 🐛 Troubleshooting

**Extension not loading?**
```bash
# Check syntax
cd ~/.omp/extensions
npx tsc --noEmit ralph-loop.ts
```

**Tool not appearing?**
```bash
omp -e ~/.omp/extensions/ralph-loop.ts --print "What tools are available?"
```

**Loop won't stop?**
- Use `/ralph-stop` command
- Check completion promise is exact: `<promise>TEXT</promise>`
- Verify condition command returns lowercase "true"

## 📝 License

MIT

---

**Your ralph loop extension is ready to use!** 🎉

Start with: `omp -e ~/.omp/extensions/ralph-loop.ts`
