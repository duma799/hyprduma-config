return {
    'kdheepak/tabline.nvim',
    config = function()
        require'tabline'.setup {
            enable = true,
            options = {
                section_separators = { '', ''},
                component_separators = {'|', "|"},
                max_bufferline_percent = 80,
                show_tabs_always = true,
                show_devicons = true,
                show_bufnr = false,
                show_filename_only = true,
                modified_italic = true,
                show_tabs_only = false,
            }
        }
    end,
    dependencies = {'nvim-lualine/lualine.nvim', 'nvim-tree/nvim-web-devicons'}
}
