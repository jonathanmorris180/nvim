local utils = require("jonathan.core.utils")

local function yank_oil_path_prompt()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry then
    vim.notify("No oil entry under cursor", vim.log.levels.WARN)
    return
  end

  local dir = oil.get_current_dir()
  local abs_path = vim.fn.fnamemodify(dir .. entry.name, ":p")
  local rel_path = vim.fn.fnamemodify(abs_path, ":.")

  vim.ui.select(
    {
      { label = "Relative path (to CWD)", value = rel_path },
      { label = "Absolute path",          value = abs_path },
    },
    {
      prompt = "Yank which path?",
      format_item = function(item)
        return item.label .. " → " .. item.value
      end,
    },
    function(choice)
      if not choice then
        return
      end

      -- Yank to unnamed register
      vim.fn.setreg('"', choice.value)
      -- Copy to system clipboard
      vim.fn.setreg("+", choice.value)

      utils.clear_prompt()
      vim.notify("Yanked & copied:\n" .. choice.value)
    end
  )
end

vim.keymap.set("n", "Y", yank_oil_path_prompt, {
  desc = "(Oil) Yank path (prompt: relative or absolute)",
})
