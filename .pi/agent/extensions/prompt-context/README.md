# Pi Prompt Editor with Conversation History

Opens the external prompt editor beside a tmux pane running `less -R +G`. The pager shows a snapshot of the active conversation branch with Pi's colours, Markdown formatting, and syntax highlighting, starting at the newest content.

## Requirements

- Pi with the current extension API (tested with 0.87.1)
- tmux and less for the conversation pane
- An external editor configured through Pi's `externalEditor` setting, `$VISUAL`, or `$EDITOR`

Pi discovers this extension through `~/.pi/agent/extensions/prompt-context/index.ts`. The dotfiles keybindings move the built-in external editor to `Ctrl+Alt+G`, freeing `Ctrl+G` for this extension.

## Usage

1. Run `/reload` in Pi after installing or changing the extension and keybindings.
2. Write a draft, then press `Ctrl+G` or run `/prompt-context`.
3. Edit the prompt on the right. The conversation occupies 45% of the original pane on the left.
4. Save and exit the editor to return the draft to Pi. This does not submit it.

With the repository's tmux bindings, use your tmux prefix followed by `h` or `l` to switch panes.

| Action | Keys |
|--------|------|
| Page up in the conversation | `b` |
| Search backward | `?text`, then Enter |
| Go to the newest content | `G` |
| Close only the conversation pane | `q` in less |
| Save the prompt and return to Pi | `:wq` in Neovim |
| Discard this editing session and preserve the original draft | `:cq` in Neovim |
| Use Pi's built-in editor without a pager | `Ctrl+Alt+G` |

Closing the editor removes the conversation pane and temporary files. Closing less early leaves the editor open. If the original tmux pane was zoomed, the extension restores its zoom afterward.

Outside tmux, the extension opens only the editor. If less is missing or tmux cannot split the pane, editing still works and Pi reports a warning when the editor closes.

## Conversation Content

- Reads the active branch through Pi's session manager, including older messages retained after compaction.
- Uses Pi's message components, active theme, output padding, and code-block indentation.
- Shows recorded user and assistant messages, tool calls and results, shell output, visible extension messages, and summaries.
- Uses built-in tool renderers with expanded results and recorded edit diffs. Rendering does not execute tools or read current files to reconstruct historical diffs.
- Respects the `hideThinkingBlock` setting; omits system prompts, hidden extension state, and provider replay signatures.
- Shows images as placeholders. Sanitizes raw content before rendering and preserves only renderer-generated ANSI colour and style sequences.
- Renders at the actual pager pane width. After resizing, close the editor and reopen it to reflow the snapshot.
- Uses a snapshot, not a live feed. In-progress responses appear only after Pi records them and you reopen the editor.

This is conversation history, not an exact view of the next model request. Compaction and context edits can change what the model receives without changing recorded history. Output already truncated before storage remains truncated; Pi's renderers also retain their own display limits.

Pi's expand/collapse controls are not interactive inside less. Custom tool names use Pi's generic renderer, and visible extension messages use its default message renderer. Extension-specific renderers and Markdown transformations are not replayed.

The extension uses a private temporary directory and owner-only prompt and transcript files. It disables less shell/editor commands, input preprocessors, and search-history persistence. It never sends the transcript back as part of the draft.

## Configuration

The extension reads Pi's user settings and trusted project settings. It does not change `$EDITOR` or Neovim configuration.

For editor commands with complex quoting, use a wrapper script and set `externalEditor` to its path. Command arguments follow Pi's existing space-splitting behaviour.

## Validation

Renderer tests require `@earendil-works/pi-coding-agent` and `@earendil-works/pi-tui` to be resolvable by Node, using the same version as Pi. Pi itself supplies these dependencies when loading the extension.

From the repository root, run the tests with Node.js 22.19 or newer:

```bash
node --test .pi/agent/extensions/prompt-context/tests/*.test.ts
```

The tests compare output with Pi's native renderers and cover active themes, highlighted code and diffs, narrow panes, tables, wide text, hidden content, terminal sanitization, prompt round trips, renderer and editor failures, cancellation, missing tools, pane cleanup, private files, and zoom restoration. They use temporary fake executables and do not alter your tmux sessions.
