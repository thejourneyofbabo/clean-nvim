local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    cpp = { "clang_format" },  -- C++ 파일에 clang_format 추가
    c = { "clang_format" },    -- C 파일에도 추가
  },
  
  formatters = {
    clang_format = {
      args = { "--style=microsoft" },  -- Microsoft 스타일 지정
    },
  },
  
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
return options
