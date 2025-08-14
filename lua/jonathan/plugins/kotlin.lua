return {
	"AlexandrosAlexiou/kotlin.nvim",
	enabled = false, -- Could be good to use in the future when the LSP isn't in "pre-alpha" and has more features
	ft = { "kotlin" },
	dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
	config = function()
		require("kotlin").setup({
			-- Optional: Specify root markers for multi-module projects
			root_markers = {
				"gradlew",
				".git",
				"mvnw",
				"settings.gradle",
			},
			-- Optional: Specify a custom Java path to run the server
			jre_path = os.getenv("JDK21"),
			-- Optional: Specify additional JVM arguments
			jvm_args = {
				"-Xmx4g",
			},
		})
	end,
}
