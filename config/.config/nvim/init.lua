vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.confirm = true
vim.o.scrolloff = 10
vim.o.winborder = 'rounded'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Autoformat after write
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

-- Sync OS and Neovim Clipboard
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Completion UI options
vim.o.completeopt = 'menuone,noinsert,popup'
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
	{ src = 'https://github.com/ThePrimeagen/99' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
}

-- Oil.nvim
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Mason.nvim
require("mason").setup()

-- Telescope.nvim
require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Telescope: find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Telescope: live grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope: buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope: help tags" })

-- Mini.nvim
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		{ mode = 'n', keys = '<leader>' },
		{ mode = 'v', keys = '<leader>' },
		{ mode = 'n', keys = 'g' },
		{ mode = 'n', keys = '[' },
		{ mode = 'n', keys = ']' },
		{ mode = 'n', keys = '<C-w>' },
		{ mode = 'i', keys = '<C-x>' },
	},
	clues = {
		-- Group labels
		{ mode = 'n', keys = '<leader>9', desc = '+99 AI' },
		{ mode = 'v', keys = '<leader>9', desc = '+99 AI' },
		{ mode = 'n', keys = '<leader>f', desc = '+find/format' },
		{ mode = 'n', keys = '<leader>g', desc = '+grep' },
		{ mode = 'n', keys = '<leader>d', desc = '+diagnostics/symbols' },
		{ mode = 'n', keys = '<leader>r', desc = '+refactor' },
		{ mode = 'n', keys = '<leader>c', desc = '+code' },

		-- Built-in clue sets
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
	window = {
		delay = 150,
		config = {
			border = 'rounded',
			width = 'auto',
			anchor = 'SW',
		},
	},
})

-- Treesitter Autocmd
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'svelte', 'javascript', 'typescript', 'lua', 'go', 'html', 'css' },
	callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'svelte',
	callback = function()
		vim.treesitter.query.set('svelte', 'highlights', [[
            (tag_name) @tag
            (attribute_name) @attribute
            (quoted_attribute_value) @string
            (attribute_value) @string
            (self_closing_tag (tag_name) @tag)
            (comment) @comment
            (text) @markup.raw
            (doctype) @keyword
        ]])
	end
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
	colors = {      -- add/modify theme and palette colors
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
	background = { -- map the value of 'background' option to a theme
		dark = "dragon", -- try "dragon" !
		light = "wave"
	},
})
vim.cmd("colorscheme kanagawa")

-- 99 (AI agent via Claude Code)
local _99 = require("99")
_99.setup({
	provider = _99.Providers.ClaudeCodeProvider,
	model = "claude-sonnet-4-5",
	tmp_dir = "./tmp",
	md_files = { "AGENT.md" },
	completion = {
		source = "native", -- works with built-in completion, no cmp/blink needed
	},
	logger = {
		print_on_error = true,
	},
})

-- 99 keymaps
vim.keymap.set("v", "<leader>9v", _99.visual, { desc = "99: edit visual selection" })
vim.keymap.set("n", "<leader>9s", _99.search, { desc = "99: search project" })
vim.keymap.set("n", "<leader>9o", _99.open, { desc = "99: open last result" })
vim.keymap.set("n", "<leader>9x", _99.stop_all_requests, { desc = "99: stop all requests" })

-- 99.nvim Autocommands
vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		local gitignore = vim.fn.getcwd() .. '/.gitignore'
		local entry = 'tmp/'
		local found = false

		if vim.fn.filereadable(gitignore) == 1 then
			for _, line in ipairs(vim.fn.readfile(gitignore)) do
				if line == entry then
					found = true
					break
				end
			end
		end

		if not found then
			vim.fn.writefile({ entry }, gitignore, 'a')
		end
	end
})

-- Telescope model/provider switcher (since you already have telescope)
vim.keymap.set("n", "<leader>9m", function()
	require("99.extensions.telescope").select_model()
end, { desc = "99: select model" })
vim.keymap.set("n", "<leader>9p", function()
	require("99.extensions.telescope").select_provider()
end, { desc = "99: select provider" })

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
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics: location list" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Diagnostics: previous" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Diagnostics: next" })
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP servers
vim.lsp.config['svelte'] = {
	cmd = { 'svelteserver', '--stdio' },
	filetypes = { 'svelte' },
	root_markers = { 'svelte.config.js', 'svelte.config.ts', 'package.json', '.git' },
}
vim.lsp.config['ts_ls'] = {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}

-- LSP Enable
vim.lsp.enable('svelte')
vim.lsp.enable('ts_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
