local M = {}

local api = vim.api

local function show_single(winid, name)
  local win_width = vim.api.nvim_win_get_width(winid)
  local win_height = vim.api.nvim_win_get_height(winid)

  -- floating window size
  local float_width = 3
  local float_height = 1

  -- position of floating window
  local row = math.floor((win_height - float_height) / 2)
  local col = math.floor((win_width - float_width) / 2)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { ' ' .. name .. ' ' })

  return api.nvim_open_win(bufnr, false, {
    relative = 'win',
    width = float_width,
    height = float_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })
end

local function show_multi()
  local fallback_win = api.nvim_get_current_win()

  local origin_wins = {}
  local selector_wins = {}
  local win_ids = vim.api.nvim_list_wins()
  local cnt = 0
  for _, win_id in ipairs(win_ids) do
    if not api.nvim_win_is_valid(win_id) then
      goto continue
    end
    cnt = cnt + 1

    local config = api.nvim_win_get_config(win_id)
    if config.focusable and cnt <= 26 then -- the numbef of maximum window is 26
      api.nvim_set_current_win(win_id)
      local selector_win_id = show_single(win_id, string.char(65 + cnt - 1))
      table.insert(origin_wins, win_id)
      table.insert(selector_wins, selector_win_id)
    end
    ::continue::
  end

  return {
    fallback_win = fallback_win,
    origin_wins = origin_wins,
    selector_wins = selector_wins,
  }
end

local function wait_for_input(callback)
  -- Wait for input asynchronously
  -- vim.uv
  --   .new_async(vim.schedule_wrap(function()
  --     local key = vim.fn.getchar()
  --     key = (type(key) == 'number') and key or 0
  --     callback(key)
  --   end))
  --   :send()

  vim.schedule(function()
    local key = vim.fn.getchar()
    key = (type(key) == 'number') and key or 0
    callback(key)
  end)
end

function M.select_window()
  local wins = show_multi()

  wait_for_input(function(key)
    -- lower to upper
    if key > 90 then
      key = key - 32
    end

    -- A to Z
    local nwins = #wins.origin_wins
    if key >= 65 and key <= 90 and key <= nwins + 65 - 1 then
      local win_id = wins.origin_wins[key - 65 + 1]
      api.nvim_set_current_win(win_id)
    else
      api.nvim_set_current_win(wins.fallback_win)
    end

    for _, id in ipairs(wins.selector_wins) do
      api.nvim_win_close(id, true)
    end
  end)
end

return M
