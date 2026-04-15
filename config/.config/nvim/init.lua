vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.confirm = true
vim.o.scrolloff = 10

-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Sync OS and Neovim Clipboard
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Completion UI options
vim.o.completeopt = 'menuone,noselect,popup'
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 40

vim.pack.add {
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/rebelot/kanagawa.nvim',
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.nvim' },
}

-- Oil.nvim
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Mason.nvim
require("mason").setup()

-- Telescope.nvim
require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Telescope: find files" })
vim.keymap.set("n", "<leader>gf", builtin.live_grep, { desc = "Telescope: live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: help tags" })

-- Mini.nvim
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()

vim.api.nvim_create_autocmd('FileType', {
	pattern = { '<filetype>' },
	callback = function() vim.treesitter.start() end,
})

-- Kanagawa.nvim
require('kanagawa').setup({
	compile = false, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false, -- do not set background color
	dimInactive = true, -- dim inactive window `:h hl-NormalNC`
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = {         -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	overrides = function(colors)
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
		}
	end,
	theme = "dragon", -- Load "wave" theme
	background = {   -- map the value of 'background' option to a theme
		dark = "dragon", -- try "dragon" !
		light = "wave"
	},
})
vim.cmd("colorscheme kanagawa")

-- LSP + Completion
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local opts = { buffer = ev.buf }

		-- Enable native LSP completion for this buffer
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
			})
		end

		-- Manual trigger (useful when autotrigger doesn't fire)
		vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, opts)

		-- Navigate completion menu with Tab/S-Tab
		vim.keymap.set("i", "<Tab>", function()
			return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
		end, { buffer = ev.buf, expr = true })
		vim.keymap.set("i", "<S-Tab>", function()
			return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
		end, { buffer = ev.buf, expr = true })
		-- Confirm selection with Enter
		vim.keymap.set("i", "<CR>", function()
			return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
		end, { buffer = ev.buf, expr = true })

		-- Navigation
		vim.keymap.set("n", "gd", vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		vim.keymap.set("n", "gr", builtin.lsp_references,
			vim.tbl_extend("force", opts, { desc = "References (Telescope)" }))
		vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols,
			vim.tbl_extend("force", opts, { desc = "Document symbols" }))

		-- Docs & info
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Signature help" }))

		-- Refactoring
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
			vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" }))

		-- Formatting
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
	end
})

-- Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics: show line" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics: previous" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics: next" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics: location list" })
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP servers
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

