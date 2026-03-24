local function yank_oil_path(mode)
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry then
    vim.notify("No oil entry under cursor", vim.log.levels.WARN)
    return
  end

  local dir = oil.get_current_dir()
  local abs_path = vim.fn.fnamemodify(dir .. entry.name, ":p")
  local path = mode == "rel" and vim.fn.fnamemodify(abs_path, ":.") or abs_path

  vim.fn.setreg('"', path)
  vim.fn.setreg("+", path)
  vim.notify("Yanked: " .. path)
end

vim.keymap.set("n", "yp", function()
  yank_oil_path("rel")
end, {
  desc = "(Oil) Yank relative path",
  buffer = true,
})

vim.keymap.set("n", "YP", function()
  yank_oil_path("abs")
end, {
  desc = "(Oil) Yank absolute path",
  buffer = true,
})
