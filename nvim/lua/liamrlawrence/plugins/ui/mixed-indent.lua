return __LazyVirtualPlugin({
    "liamrlawrence/mixed-indent.nvim",

    config = function()
        local TAB     = [[^\s*\t\s*\S]]
        local SPACE   = [[^ [ \t]\s*\S]]
        local TIMEOUT = 50

        local scanned = {}

        local function continues(parser, lnum)
            if vim.fn.getline(lnum):find("^%s*[&|?:.]") then return true end
            local prev = vim.fn.getline(lnum - 1):match("^(.-)%s*$")
            local tail = prev ~= "" and parser:named_node_for_range({ lnum - 2, #prev - 1, lnum - 2, #prev - 1 })
            if tail and tail:type():find("comment") then
                local srow, scol = tail:start()
                prev = srow == lnum - 2 and prev:sub(1, scol):match("^(.-)%s*$") or ""
            end
            return prev:find("[-+*/%%&|^=?,\\]$") ~= nil
        end

        local function is_alignment(parser, lnum)
            local row = lnum - 1
            local col = #vim.fn.getline(lnum):match("^%s*")
            local node = parser:named_node_for_range({ row, col, row, col })
            while node do
                local srow = node:start()
                if node:type():find("comment") then return true end
                if srow < row then
                    if node:type():find("string") then return true end
                    local open, first = node:child(0), node:child(1)
                    if open and open:type():find("^[%(%[{<]$") then
                        return first ~= nil and first:start() == srow and not first:type():find("comment")
                    end
                    return continues(parser, lnum)
                end
                node = node:parent()
            end
            return false
        end

        local function first_space_indent(parser)
            local flags, stop = "cW", vim.uv.hrtime() + TIMEOUT * 1e6
            while vim.uv.hrtime() < stop do
                local lnum = vim.fn.search(SPACE, flags, 0, TIMEOUT)
                if lnum == 0 or not (parser and is_alignment(parser, lnum)) then return lnum end
                flags = "W"
            end
            return 0
        end

        local function check(buf)
            if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then return end
            local tick = vim.api.nvim_buf_get_changedtick(buf)
            if scanned[buf] == tick then return end

            local parser = vim.treesitter.get_parser(buf)
            if parser and not parser:parse(nil, function(err)
                if err then return end
                vim.schedule(function()
                    if buf == vim.api.nvim_get_current_buf() then check(buf) end
                end)
            end) then
                return
            end
            scanned[buf] = tick

            local view = vim.fn.winsaveview()
            vim.fn.cursor(1, 1)
            local tab   = vim.fn.search(TAB, "cnW", 0, TIMEOUT)
            local space = tab > 0 and first_space_indent(parser) or 0
            vim.fn.winrestview(view)

            local line = (tab > 0 and space > 0) and math.max(tab, space) or nil
            if vim.b[buf].mixed_indent ~= line then
                vim.b[buf].mixed_indent = line
                vim.cmd.redrawstatus()
            end
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
            group = vim.api.nvim_create_augroup("MixedIndent", { clear = true }),
            callback = function(args) check(args.buf) end,
        })

        vim.keymap.set("n", "<leader>emi", function()
            local line = vim.b.mixed_indent
            if line then
                vim.cmd("normal! " .. line .. "G")
            else
                vim.notify("No mixed indentation")
            end
        end, { desc = "Jump to first mixed-indent line" })
    end
})

