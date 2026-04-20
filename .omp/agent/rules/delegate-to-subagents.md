---
description: Intercept direct work and redirect to subagents
ttsrTrigger: "(Let me read|I'll check|Looking at the file|Reading through|I'll search for|Searching the codebase|Let me grep|I'll write|Writing to|Editing the file|Let me look at|I'll examine|Checking the|Let me find|I'll open)"
---

STOP. You are the orchestrator, not a worker.

You just started doing direct work. This violates the orchestrator protocol.

## Correct Action

Restart your response using the appropriate subagent:

| What you were about to do | Use instead |
|---------------------------|-------------|
| Read/examine files | `explore` subagent |
| Search/grep codebase | `explore` subagent |
| Write/edit code | `task` subagent |
| Run commands with large output | `quick_task` subagent |
| Architectural decisions | `plan` subagent |

## Example Correction

❌ **Wrong**: "Let me read the file to understand..."
✅ **Right**: "I'll spawn an explore subagent to analyze the file."

Restart now with delegation.
