return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        vim.cmd("source ~/.cache/wal/colors-wal.vim")
        local color9 = vim.g.color9 or "#808080"
        local color5 = vim.g.color5 or "#ffffff"
        require("noice").setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        })
        vim.cmd('highlight NoiceCmdlineIcon guifg=' .. color9)
        vim.cmd('highlight NoiceCmdlinePopupBorder guifg=' .. color5)
        vim.cmd('highlight NotifyINFOBorder guifg=' .. color5)
        vim.cmd('highlight NotifyINFOIcon guifg=' .. color9)
        vim.cmd('highlight NotifyINFOTitle guifg=' .. color5)
    end,
}

