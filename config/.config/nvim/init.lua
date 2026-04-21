-- OPTIONS
vim.g.mapleader      = " "
vim.o.number         = true
vim.o.relativenumber = true
vim.o.signcolumn     = 'yes:1'
vim.o.confirm        = true
vim.o.scrolloff      = 10
vim.o.winborder      = 'rounded'
vim.o.completeopt    = 'menuone,noinsert,popup'
vim.o.pumborder      = 'rounded'
vim.o.pummaxwidth    = 40

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- KEYMAPS
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- AUTOCMDS
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	desc = 'Autoformat on save',
	callback = function() vim.lsp.buf.format({ async = false }) end,
})

vim.api.nvim_create_autocmd('FileType', {
	desc = 'Start treesitter for supported filetypes',
	pattern = { 'svelte', 'javascript', 'typescript', 'lua', 'go', 'html', 'css' },
	callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
	desc = 'Svelte HTML highlighting',
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
	end,
})

vim.api.nvim_create_autocmd('VimEnter', {
	desc = 'Add tmp/ to .gitignore',
	callback = function()
		local gitignore = vim.fn.getcwd() .. '/.gitignore'
		local entry = 'tmp/'
		local found = false
		if vim.fn.filereadable(gitignore) == 1 then
			for _, line in ipairs(vim.fn.readfile(gitignore)) do
				if line == entry then
					found = true; break
				end
			end
		end
		if not found then vim.fn.writefile({ entry }, gitignore, 'a') end
	end,
})

-- PLUGINS
vim.pack.add {
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/rebelot/kanagawa.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.nvim' },
	{ src = 'https://github.com/ThePrimeagen/99' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/nvim-lualine/lualine.nvim' },
}

-- Kanagawa --
require('kanagawa').setup({
	compile        = true,
	undercurl      = true,
	commentStyle   = { italic = true },
	keywordStyle   = { italic = true },
	statementStyle = { bold = true },
	functionStyle  = {},
	typeStyle      = {},
	transparent    = false,
	dimInactive    = true,
	terminalColors = true,
	colors         = { palette = {}, theme = { wave = {}, lotus = {}, dragon = {}, all = {} } },
	theme          = 'dragon',
	background     = { dark = 'dragon', light = 'wave' },
	overrides      = function(colors)
		local t = colors.theme
		return {
			Pmenu      = { fg = t.ui.shade0, bg = t.ui.bg_p1 },
			PmenuSel   = { fg = 'NONE', bg = t.ui.bg_p2 },
			PmenuSbar  = { bg = t.ui.bg_m1 },
			PmenuThumb = { bg = t.ui.bg_p2 },
		}
	end,
})
vim.cmd('colorscheme kanagawa')

-- Lualine --
require('lualine').setup({ options = { theme = 'kanagawa' } })

-- Oil --
require('oil').setup({ view_options = { show_hidden = true } })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Oil: open parent directory' })

-- Mason --
require('mason').setup()

-- Telescope --
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope: find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope: live grep' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Telescope: buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Telescope: help tags' })

-- Mini --
require('mini.ai').setup({ n_lines = 500 })
require('mini.diff').setup()
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
		{ mode = 'n', keys = '<leader>9', desc = '+99 AI' },
		{ mode = 'v', keys = '<leader>9', desc = '+99 AI' },
		{ mode = 'n', keys = '<leader>f', desc = '+find/format' },
		{ mode = 'n', keys = '<leader>g', desc = '+grep' },
		{ mode = 'n', keys = '<leader>d', desc = '+diagnostics/symbols' },
		{ mode = 'n', keys = '<leader>r', desc = '+refactor' },
		{ mode = 'n', keys = '<leader>c', desc = '+code' },
		{ mode = 'n', keys = '<leader>s', desc = '+search' },
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
	window = {
		delay = 150,
		config = { border = 'rounded', width = 'auto', anchor = 'SW' },
	},
})

-- 99 --
local _99 = require('99')
_99.setup({
	provider   = _99.Providers.ClaudeCodeProvider,
	model      = 'claude-sonnet-4-5',
	tmp_dir    = './tmp',
	md_files   = { 'AGENT.md' },
	completion = { source = 'native' },
	logger     = { print_on_error = true },
})

vim.keymap.set('v', '<leader>9v', _99.visual, { desc = '99: edit visual selection' })
vim.keymap.set('n', '<leader>9s', _99.search, { desc = '99: search project' })
vim.keymap.set('n', '<leader>9o', _99.open, { desc = '99: open last result' })
vim.keymap.set('n', '<leader>9x', _99.stop_all_requests, { desc = '99: stop all requests' })
vim.keymap.set('n', '<leader>9m', function() require('99.extensions.telescope').select_model() end,
	{ desc = '99: select model' })
vim.keymap.set('n', '<leader>9p', function() require('99.extensions.telescope').select_provider() end,
	{ desc = '99: select provider' })

-- LSP
vim.lsp.config['svelte'] = {
	cmd          = { 'svelteserver', '--stdio' },
	filetypes    = { 'svelte' },
	root_markers = { 'svelte.config.js', 'svelte.config.ts', 'package.json', '.git' },
}
vim.lsp.config['ts_ls'] = {
	cmd          = { 'typescript-language-server', '--stdio' },
	filetypes    = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}

vim.lsp.enable('svelte')
vim.lsp.enable('ts_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP keymaps and completion',
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local opts   = { buffer = ev.buf }

		-- Completion
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Completion navigation
		vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, opts)
		vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end,
			{ buffer = ev.buf, expr = true })
		vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end,
			{ buffer = ev.buf, expr = true })
		vim.keymap.set('i', '<CR>', function() return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>' end,
			{ buffer = ev.buf, expr = true })

		-- Navigation
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
			vim.tbl_extend('force', opts, { desc = 'LSP: go to definition' }))
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
			vim.tbl_extend('force', opts, { desc = 'LSP: go to declaration' }))
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
			vim.tbl_extend('force', opts, { desc = 'LSP: go to implementation' }))
		vim.keymap.set('n', 'gr', builtin.lsp_references,
			vim.tbl_extend('force', opts, { desc = 'LSP: references' }))
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: hover docs' }))
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
			vim.tbl_extend('force', opts, { desc = 'LSP: signature help' }))
		vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols,
			vim.tbl_extend('force', opts, { desc = 'LSP: document symbols' }))

		-- Refactor
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
			vim.tbl_extend('force', opts, { desc = 'LSP: rename' }))
		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
			vim.tbl_extend('force', opts, { desc = 'LSP: code action' }))
		vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end,
			vim.tbl_extend('force', opts, { desc = 'LSP: format buffer' }))
	end,
})

-- DIAGNOSTICS
vim.diagnostic.config({
	virtual_text     = true,
	signs            = true,
	underline        = true,
	update_in_insert = false,
	severity_sort    = true,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Diagnostics: show line' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics: location list' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Diagnostics: previous' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Diagnostics: next' })
