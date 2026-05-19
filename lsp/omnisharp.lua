return {
  cmd = {
    vim.fn.expand("~/.local/share/nvim/mason/bin/omnisharp"),
    "-z",
    "--languageserver",
    "--hostPID",
    tostring(vim.fn.getpid()),
  },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj", "omnisharp.json" },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
    },
  },
}
