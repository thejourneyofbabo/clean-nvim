require "nvchad.mappings"

-- General mappings
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Nvim DAP Mappings
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc>", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- Rust-specific Mappings
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
map("n", "<Leader>k", function()
  vim.cmd.RustLsp { "hover", "actions" }
end, { desc = "Rust hover actions" })
map("n", "<Leader>dd", "<cmd>RustLsp debuggables<CR>", { desc = "List available debug targets" })
map("n", "<Leader>dr", "<cmd>RustLsp debug<CR>", { desc = "Start debugging" })
map("n", "<Leader>rr", "<cmd>RustLsp runnables<CR>", { desc = "List runnable targets" })
map("n", "<Leader>rc", "<cmd>RustLsp run<CR>", { desc = "Run current target" })
map("n", "<Leader>tt", "<cmd>RustLsp testables<CR>", { desc = "List testable targets" })
map("n", "<Leader>ca", "<cmd>RustLsp codeAction<CR>", { desc = "Show code actions" })
map("n", "<Leader>em", "<cmd>RustLsp expandMacro<CR>", { desc = "Expand macro recursively" })
map("n", "<Leader>mu", "<cmd>RustLsp moveItem up<CR>", { desc = "Move item up" })
map("n", "<Leader>md", "<cmd>RustLsp moveItem down<CR>", { desc = "Move item down" })
map("n", "<Leader>ee", "<cmd>RustLsp explainError<CR>", { desc = "Explain error" })
map("n", "<Leader>od", "<cmd>RustLsp openDocs<CR>", { desc = "Open docs.rs documentation" })
map("n", "<Leader>pm", "<cmd>RustLsp parentModule<CR>", { desc = "Go to parent module" })
map("n", "<Leader>ws", "<cmd>RustLsp workspaceSymbol<CR>", { desc = "Search workspace symbols" })
map("n", "<Leader>jl", "<cmd>RustLsp joinLines<CR>", { desc = "Join lines" })
map("n", "<Leader>sr", "<cmd>RustLsp ssr<CR>", { desc = "Structural search replace" })
map("n", "<Leader>vg", "<cmd>RustLsp crateGraph<CR>", { desc = "View crate graph" })
map("n", "<Leader>vs", "<cmd>RustLsp syntaxTree<CR>", { desc = "View syntax tree" })
map("n", "<Leader>vh", "<cmd>RustLsp view hir<CR>", { desc = "View HIR" })
map("n", "<Leader>vm", "<cmd>RustLsp view mir<CR>", { desc = "View MIR" })
map("n", "<Leader>fc", "<cmd>RustLsp flyCheck run<CR>", { desc = "Run fly check" })

-- Window Navigation
map("n", "C-h", "<cmd> TmuxNvigateLeft<CR>", { desc = "Window left" })
map("n", "C-l", "<cmd> TmuxNvigateRight<CR>", { desc = "Window right" })
map("n", "C-j", "<cmd> TmuxNvigateDown<CR>", { desc = "Window down" })
map("n", "C-k", "<cmd> TmuxNvigateUp<CR>", { desc = "Window up" })

-- LSP Mappings
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition" })
map("n", "gdv", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", { desc = "LSP definition (vertical split)" })
map(
  "n",
  "gdh",
  "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>",
  { desc = "LSP definition (horizontal split)" }
)

-- Cursor Movement
map("n", "<leader>lj", "10jzz", { desc = "Move cursor up by 10 lines" })
map("n", "<leader>lk", "10kzz", { desc = "Move cursor down by 10 lines" })

-- DAP Python
map("n", "<Leader>dpr", function()
  require("dap-python").test_method()
end, { desc = "Test Python method" })

-- Run entire Python file
-- map("n", "<Leader>pr", function()
--   vim.cmd "!python3 %"
-- end, { desc = "Run Python file" })

-- Run entire Python file
map("n", "<Leader>pr", function()
  vim.cmd("split | terminal python3 " .. vim.fn.expand "%")
end, { desc = "Run Python file" })

-- Run current line with buffer context and show buffer
map("n", "<Leader>pl", function()
  local line = vim.fn.getline "."

  -- Initialize buffer if not exists
  if not _G.python_buffer then
    _G.python_buffer = {}
  end

  -- Add current line to buffer
  table.insert(_G.python_buffer, line)

  -- Show buffer content
  print "Python buffer:"
  for i, buf_line in ipairs(_G.python_buffer) do
    print(i .. ": " .. buf_line)
  end

  -- Create temp file and run in terminal
  local temp_file = vim.fn.tempname() .. ".py"
  vim.fn.writefile(_G.python_buffer, temp_file)
  vim.cmd("split | terminal python3 " .. temp_file .. "; rm " .. temp_file)
end, { desc = "Run current line with context" })

-- Run from last executed line to current line (incremental)
map("n", "<Leader>pll", function()
  local current_line = vim.fn.line "."

  -- Initialize buffer and last line tracker
  if not _G.python_buffer then
    _G.python_buffer = {}
  end
  if not _G.last_executed_line then
    _G.last_executed_line = 0
  end

  -- Get lines from last executed to current
  local start_line = _G.last_executed_line + 1
  local new_lines = vim.fn.getline(start_line, current_line)

  -- Ensure new_lines is always a table
  if type(new_lines) == "string" then
    new_lines = { new_lines }
  end

  -- Add new lines to buffer
  for _, line in ipairs(new_lines) do
    table.insert(_G.python_buffer, line)
  end

  -- Update last executed line
  _G.last_executed_line = current_line

  -- Show what was added and run in terminal
  print("Added lines " .. start_line .. " to " .. current_line .. " to buffer")
  local temp_file = vim.fn.tempname() .. ".py"
  vim.fn.writefile(_G.python_buffer, temp_file)
  vim.cmd("split | terminal python3 " .. temp_file .. "; rm " .. temp_file)
end, { desc = "Run from last to current line" })

-- Clear Python buffer
map("n", "<Leader>pc", function()
  _G.python_buffer = {}
  _G.last_executed_line = 0
  print "Python buffer cleared"
end, { desc = "Clear Python buffer" })

-- DAP Miscellaneous
map("n", "<Leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })
map("n", "<Leader>dx", "<cmd>DapTerminate<CR>", { desc = "Terminate debugger" })

-- C++ specific mappings
map("n", "<Leader>cc", function()
  local filename = vim.fn.expand "%:p" -- Get full path
  local directory = vim.fn.expand "%:p:h" -- Get directory
  local file_basename = vim.fn.expand "%:t:r" -- Get filename without extension

  -- Create bin directory if it doesn't exist
  local bin_dir = directory .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  -- Set output path to bin directory
  local output_path = bin_dir .. "/" .. file_basename

  -- Save the file
  vim.cmd "write"

  -- Change to file's directory and execute in terminal
  vim.cmd(
    string.format(
      "new | terminal cd %s && g++ %s -o %s && %s",
      vim.fn.shellescape(directory),
      vim.fn.shellescape(filename),
      vim.fn.shellescape(output_path),
      vim.fn.shellescape(output_path)
    )
  )

  -- Enter insert mode in terminal
  vim.cmd "startinsert"
end, { desc = "Compile and run C++" })

-- Compile only
map("n", "<Leader>cb", function()
  local filename = vim.fn.expand "%:p"
  local directory = vim.fn.expand "%:p:h"
  local file_basename = vim.fn.expand "%:t:r"

  -- Create bin directory if it doesn't exist
  local bin_dir = directory .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  -- Set output path to bin directory
  local output_path = bin_dir .. "/" .. file_basename

  -- Save the file
  vim.cmd "write"

  -- Compile
  vim.cmd(string.format("!g++ %s -o %s", vim.fn.shellescape(filename), vim.fn.shellescape(output_path)))
end, { desc = "Compile C++ only" })

-- C++ with debug symbols
map("n", "<Leader>cd", function()
  local filename = vim.fn.expand "%:p"
  local directory = vim.fn.expand "%:p:h"
  local file_basename = vim.fn.expand "%:t:r"

  -- Create bin directory if it doesn't exist
  local bin_dir = directory .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  -- Set output path to bin directory
  local output_path = bin_dir .. "/" .. file_basename

  -- Save the file
  vim.cmd "write"

  -- Compile with debug symbols
  vim.cmd(string.format("!g++ -g %s -o %s", vim.fn.shellescape(filename), vim.fn.shellescape(output_path)))
end, { desc = "Compile C++ with debug symbols" })

-- C++ with optimization
map("n", "<Leader>co", function()
  local filename = vim.fn.expand "%:p"
  local directory = vim.fn.expand "%:p:h"
  local file_basename = vim.fn.expand "%:t:r"

  -- Create bin directory if it doesn't exist
  local bin_dir = directory .. "/bin"
  vim.fn.mkdir(bin_dir, "p")

  -- Set output path to bin directory
  local output_path = bin_dir .. "/" .. file_basename

  -- Save the file
  vim.cmd "write"

  -- Compile with optimization
  vim.cmd(string.format("!g++ -O2 -Wall %s -o %s", vim.fn.shellescape(filename), vim.fn.shellescape(output_path)))
end, { desc = "Compile C++ with optimization" })
