local Buffman = {}

Buffman.keymaps = {
    delete_selected_buffer = "d",
    quit = "q",
    open_selected_buffer = "<CR>"
}

Buffman.config = {
    full_buffer_names = false
}

local function create_buffer()
    Buffman.buffer_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(
        Buffman.buffer_id,
        "n",
        Buffman.keymaps.open_selected_buffer,
        "<cmd>lua require('buffman').switch_to_selected_buffer()<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        Buffman.buffer_id,
        "n",
        Buffman.keymaps.delete_selected_buffer,
        "<cmd>lua require('buffman').delete_selected_buffer()<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        Buffman.buffer_id,
        "n",
        Buffman.keymaps.quit,
        "<cmd>bd<CR>",
        { noremap = true, silent = true }
    )
end


local function create_window()
    local width = math.floor(vim.o.columns * 0.4)
    local height = math.floor(vim.o.lines * 0.3)
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = 0;
        col = vim.o.columns - width,
        border = "none",
    }
    Buffman.window_id = vim.api.nvim_open_win(Buffman.buffer_id, true, opts)
end

local function fill_buffer()
    local buffer_ids = vim.api.nvim_list_bufs()
    local lines = {}

    for _, buffer_id in ipairs(buffer_ids) do
        if buffer_id == Buffman.buffer_id then
            goto continue
        end
        if vim.api.nvim_buf_is_loaded(buffer_id) then
            local buf_name = vim.api.nvim_buf_get_name(buffer_id)
            local file_name = buf_name
            if not Buffman.config.full_buffer_names then
                file_name = buf_name:match("^.+[/\\](.+)$")
            end
            table.insert(lines, string.format("%d: %s", buffer_id,
                                              file_name == "" and "[No Name]" or file_name))
        end
        ::continue::
    end
    vim.api.nvim_buf_set_lines(Buffman.buffer_id, 0, -1, false, lines)
end

local function is_buffer_opened_in_any_window(buf_id)
  local windows = vim.api.nvim_list_wins()

  for _, win_id in ipairs(windows) do
    if vim.api.nvim_win_get_buf(win_id) == buf_id then
      return true
    end
  end

  return false
end

function Buffman.open_buffman()
    if Buffman.buffer_id and is_buffer_opened_in_any_window(Buffman.buffer_id) then
        return
    end
    create_buffer()
    create_window()
    fill_buffer()
end

function Buffman.switch_to_selected_buffer()
    local line = vim.fn.line(".")
    local selected_buffer_id = tonumber(vim.api.nvim_buf_get_lines(Buffman.buffer_id, line - 1,
                                                                line,false)[1]:match("^%d+"))
    if selected_buffer_id then
        vim.api.nvim_win_close(Buffman.window_id, true)
        vim.api.nvim_buf_delete(Buffman.buffer_id, {force = true})
        vim.api.nvim_set_current_buf(selected_buffer_id)
    end
end

local function is_buffer_writable(buffer_id)
    local file_name = vim.api.nvim_buf_get_name(buffer_id)
    if file_name == "" then
        return false
    elseif vim.api.nvim_get_option_value("readonly", {buf = buffer_id}) then
        return false
    end
    return true
end

function Buffman.delete_selected_buffer()
    local line = vim.fn.line(".")
    local selected_buffer_id = tonumber(vim.api.nvim_buf_get_lines(Buffman.buffer_id, line - 1,
                                                                line,false)[1]:match("^%d+"))
    if selected_buffer_id then
        if is_buffer_writable(selected_buffer_id) then
            vim.api.nvim_buf_call(selected_buffer_id, function()
                vim.cmd("write")
            end)
        end
        vim.api.nvim_buf_delete(selected_buffer_id, {})
        vim.api.nvim_buf_set_lines(Buffman.buffer_id, line - 1, line, false, {})
    end
end

return Buffman
