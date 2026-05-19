return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.cs = { lsp_format = "prefer" }

      if opts.format_on_save then
        local original_format_on_save = opts.format_on_save
        opts.format_on_save = function(bufnr)
          if vim.bo[bufnr].filetype == "cs" then
            return nil
          end
          if type(original_format_on_save) == "function" then
            return original_format_on_save(bufnr)
          end
          return original_format_on_save
        end
      end
    end,
  },
}
