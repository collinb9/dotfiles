/**
 * Ask Always Available
 *
 * Ensures the 'ask' tool (from pi-ask-tool) is always available,
 * even when other extensions (like plannotator) restrict the active tools.
 *
 * Uses the before_agent_start hook to inject 'ask' into active tools
 * before each agent turn, without modifying other extensions.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function askAlwaysAvailable(pi: ExtensionAPI) {
  // Before each agent turn, ensure 'ask' is in active tools
  pi.on("before_agent_start", async (_event, _ctx) => {
    ensureAskAvailable();
  });

  // Also ensure on session start (after other extensions have initialized)
  pi.on("session_start", async (_event, _ctx) => {
    // Small delay to let other extensions (like plannotator) set their tools first
    setTimeout(() => ensureAskAvailable(), 100);
  });

  function ensureAskAvailable() {
    const allToolNames = pi.getAllTools().map((t) => t.name);

    // Only proceed if 'ask' tool exists (pi-ask-tool is installed)
    if (!allToolNames.includes("ask")) {
      return;
    }

    const activeTools = pi.getActiveTools();

    // Add 'ask' if it's not already active
    if (!activeTools.includes("ask")) {
      pi.setActiveTools([...activeTools, "ask"]);
    }
  }
}
