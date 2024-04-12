return {
	"lervag/vimtex",
	init = function()
		vim.g["vimtex_view_method"] = "skim"
		vim.g["vimtex_context_pdf_viewer"] = "skim" -- external PDF viewer run from vimtex menu command
		vim.g["vimtex_log_ignore"] = {} -- Error suppression
	end,
}
