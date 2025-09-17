return {
	"AlexandrosAlexiou/kotlin.nvim",
	ft = { "kotlin" },
	commit = "42131cb44fe151019a62667466b36c363a1bd1a2",
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
			jre_path = os.getenv("JAVA_HOME"),
			-- Optional: Specify additional JVM arguments
			jvm_args = {
				"-Xmx6g", -- Maximum heap size = 6G
			},
		})
	end,
}
