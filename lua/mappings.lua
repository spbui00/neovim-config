require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "lf", vim.diagnostic.open_float, { desc = "LSP Diagnostics" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map('i', '<C-l>', function ()
  vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
end, { desc = 'Copilot Accept', noremap = true, silent = true })

map("n", "<C-t>", function()
  require("menu").open("default")
end, {})

map("n", "gp", function()
  -- Request the definition from the LSP
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      print("No definition found")
      return
    end

    -- Extract URI and Range from the LSP response
    local res = result[1] or result
    local uri = res.uri or res.targetUri
    local range = res.range or res.targetSelectionRange
    if not uri or not range then return end

    -- Load the target buffer
    local bufnr = vim.uri_to_bufnr(uri)
    vim.fn.bufload(bufnr) 

    -- Safely execute UI changes
    vim.schedule(function()
      local current_win = vim.api.nvim_get_current_win()
      local target_win = nil

      -- Look for an existing adjacent window to reuse
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if w ~= current_win then
          target_win = w
          break
        end
      end

      -- If no adjacent window exists, create a vertical split explicitly to the RIGHT
      if not target_win then
        vim.cmd("rightbelow vsplit")
        target_win = vim.api.nvim_get_current_win()
        -- Instantly return focus to the original window
        vim.api.nvim_set_current_win(current_win) 
      end

      -- Push the definition to the target window
      vim.api.nvim_win_set_buf(target_win, bufnr)
      vim.api.nvim_win_set_cursor(target_win, { range.start.line + 1, range.start.character })
      
      -- Center the view in the target window
      vim.api.nvim_win_call(target_win, function()
        vim.cmd("normal! zz")
      end)

      -- Equalize all window widths so they are exactly 50/50
      vim.cmd("wincmd =")
    end)
  end)
end, { desc = "Peek definition in right window (equal width)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

