return {
  "jonathanmorris180/salesforce.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  dev = false,
  config = function()
    require("salesforce").setup({
      file_manager = {
        ignore_conflicts = true,
      },
    })
    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>se",
      "<cmd>SalesforceExecuteFile<cr>",
      { desc = "(Salesforce) Execute current anonymous apex file" }
    )
    keymap.set("n", "<leader>sc", "<cmd>SalesforceClosePopup<cr>", { desc = "(Salesforce) Close Salesforce popup" })
    keymap.set("n", "<leader>sS", "<cmd>SalesforceRefocusPopup<cr>", { desc = "(Salesforce) Refocus Salesforce popup" })
    keymap.set(
      "n",
      "<leader>stm",
      "<cmd>SalesforceExecuteCurrentMethod<cr>",
      { desc = "(Salesforce) Execute current Salesforce test method" }
    )
    keymap.set(
      "n",
      "<leader>stc",
      "<cmd>SalesforceExecuteCurrentClass<cr>",
      { desc = "(Salesforce) Execute current Salesforce test class" }
    )
    keymap.set("n", "<leader>sp", "<cmd>SalesforcePushToOrg<cr>", { desc = "(Salesforce) Push to org" })
    keymap.set("n", "<leader>sr", "<cmd>SalesforceRetrieveFromOrg<cr>", { desc = "(Salesforce) Retrieve from org" })
    keymap.set("n", "<leader>sd", "<cmd>SalesforceDiffFile<cr>", { desc = "(Salesforce) Diff Salesforce file" })
    keymap.set("n", "<leader>so", "<cmd>SalesforceSetDefaultOrg<cr>", { desc = "(Salesforce) Set default org" })
    keymap.set("n", "<leader>ss", "<cmd>SalesforceRefreshOrgInfo<cr>", { desc = "(Salesforce) Refresh org info" })
  end,
}
