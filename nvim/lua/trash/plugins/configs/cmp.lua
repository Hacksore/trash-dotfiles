-- vsnip
vim.g.vsnip_filetypes = {
	javascriptreact = { "javascript" },
	typescriptreact = { "typescript" },
}

-- vim.keymap.set('i', '<C-j>', 'vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<C-j>"', { desc = 'Vsnip jump to next node' })
-- vim.keymap.set('s', '<C-j>', 'vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<C-j>"', { desc = 'Vsnip jump to next node' })
-- vim.keymap.set('i', '<C-k>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { desc = 'Vsnip jump to previous node' })
-- vim.keymap.set('s', '<C-k>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { desc = 'Vsnip jump to previous node' })

-- Setup nvim-cmp
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},

	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),

		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	},

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),

	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered("rounded"),
	},

	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol_text",
			menu = {
				buffer = "[BUF]",
				nvim_lsp = "[LSP]",
				vsnip = "[SNIP]",
				path = "[PATH]",
			},
		}),
	},
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
