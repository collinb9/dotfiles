import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.setLabel("Test Extension");
	
	pi.on("session_start", async (_event, ctx) => {
		ctx.ui.notify("🧪 TEST EXTENSION LOADED AND ACTIVATED!", "info");
	});
	
	pi.registerCommand("test-ext", {
		description: "Test if extension is working",
		handler: async (_args, ctx) => {
			ctx.ui.notify("✓ Test extension command executed successfully!", "info");
		},
	});
}
