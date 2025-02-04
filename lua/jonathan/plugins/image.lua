-- There are a few requirements to get this plugin working properly (see requirements at https://github.com/3rd/image.nvim):
-- 1. imagemagick needs to be installed with `brew install imagemagick`
-- 2. Tmux settings must be correct
-- 3. Plugin must be configured correctly
--
-- Note that there are still a few issues even when it's set up correctly:
--
-- 1. Images aren't displayed correctly when lines are wrapped (see https://github.com/3rd/image.nvim/issues/263)
-- 2. If the image is rendered and you move between tmux sessions or windows, the image will still be displayed (moving between windows causes a weird glitchy behavior) - due to this, it's probably best to keep only_render_image_at_cursor set to true for now
return {
	"3rd/image.nvim",
	opts = {
		backend = "kitty",
		kitty_method = "normal",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = true,
				resolve_image_path = function(document_path, image_path, fallback)
					local working_dir = vim.fn.getcwd()
					-- Format image path for Obsidian notes
					local obsidian_client = require("obsidian").get_client()
					if working_dir:find(obsidian_client:vault_root().filename) then
						if image_path:find("|") then
							image_path = vim.split(image_path, "|")[1]
						end
						local assets_dir = "assets"
						local result =
							string.format("%s/%s/%s", obsidian_client:vault_root().filename, assets_dir, image_path)
						return result
					end
					-- Fallback to the default behavior
					return fallback(document_path, image_path)
				end,
			},
		},
		max_height_window_percentage = 40,
		tmux_show_only_in_active_window = true,
		-- render image files as images when opened
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
	},
}
