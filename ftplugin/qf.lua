local utils = require("jonathan.core.utils")

vim.keymap.set("n", "dd", utils.del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
