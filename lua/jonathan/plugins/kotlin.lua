return {
  "AlexandrosAlexiou/kotlin.nvim",
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
      jre_path = vim.fn.expand("$HOME/.sdkman/candidates/java/21.0.3-tem"),
      -- Optional: Specify additional JVM arguments
      jvm_args = {
        "-Xmx6g", -- Maximum heap size = 6G
      },
    })
  end,
}
