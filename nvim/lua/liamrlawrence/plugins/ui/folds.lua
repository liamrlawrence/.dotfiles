return __LazyVirtualPlugin({
    "liamrlawrence/folds.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },  -- provides the @function.outer queries

    config = function()
        local fold_group = vim.api.nvim_create_augroup("LL.plugins_fold-group", { clear = true })

        -- Normal's foreground on Folded's background, for text treesitter doesn't capture
        local function set_hl()
            vim.api.nvim_set_hl(0, "LL.FoldText", {
                fg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg,
            })
        end
        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Recreate fold text highlight after colorscheme change",
            group = fold_group,
            callback = set_hl,
        })

        --- 0-indexed start/end rows of the innermost @function.outer under the cursor, or nil
        local function function_range_at_cursor()
            local ok, parser = pcall(vim.treesitter.get_parser, 0)
            if not ok or not parser then return nil end

            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            row = row - 1
            local cur_line = vim.api.nvim_get_current_line()
            col = math.max(col, (cur_line:find("%S") or 1) - 1)  -- indentation counts as the first token
            parser:parse({ row, row + 1 })

            local lang_tree = parser:language_for_range({ row, col, row, col })
            local query = vim.treesitter.query.get(lang_tree:lang(), "textobjects")
            if not query then return nil end

            local best, best_size
            for _, tree in ipairs(lang_tree:trees()) do
                for id, node in query:iter_captures(tree:root(), 0, row, row + 1) do
                    if query.captures[id] == "function.outer"
                        and vim.treesitter.is_in_node_range(node, row, col) then
                        local sr, _, er, _ = node:range()
                        if not best or (er - sr) < best_size then
                            best, best_size = node, er - sr
                        end
                    end
                end
            end
            if not best then return nil end

            local sr, _, er, ec = best:range()
            if ec == 0 and er > sr then er = er - 1 end
            return sr, er
        end

        local function foldtext()
            local bufnr = vim.api.nvim_get_current_buf()
            local lnum  = vim.v.foldstart - 1
            local line  = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
            local first = (line:find("%S") or (#line + 1)) - 1

            -- Per-byte highlight groups from treesitter's highlights query
            local hls = {}
            local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
            if ok and parser then
                local query = vim.treesitter.query.get(parser:lang(), "highlights")
                local tree  = parser:trees()[1] or parser:parse()[1]
                if query and tree then
                    for id, node in query:iter_captures(tree:root(), bufnr, lnum, lnum + 1) do
                        local name = query.captures[id]
                        if not name:match("^_") then
                            local sr, sc, er, ec = node:range()
                            if sr < lnum then sc = 0 end
                            if er > lnum then ec = #line end
                            for c = sc, ec - 1 do hls[c] = "@" .. name end
                        end
                    end
                end
            end

            -- "+" followed by dashes up to one column before the text; nothing at column 0
            local indent = vim.fn.indent(vim.v.foldstart)
            local prefix = indent == 0 and "" or ("+" .. string.rep("-", math.max(indent - 2, 0)))
            local pad = prefix .. string.rep(" ", indent - #prefix)

            local chunks = {}
            if pad ~= "" then table.insert(chunks, { pad, "Folded" }) end

            local text, cur = "", nil
            local tab = string.rep(" ", vim.bo[bufnr].tabstop)
            for c = first, #line - 1 do
                local hl = hls[c] or "LL.FoldText"
                if hl ~= cur and text ~= "" then
                    table.insert(chunks, { text, cur })
                    text = ""
                end
                cur = hl
                local ch = line:sub(c + 1, c + 1)
                text = text .. (ch == "\t" and tab or ch)
            end
            if text ~= "" then table.insert(chunks, { text, cur }) end

            table.insert(chunks, { ("  %d lines:"):format(vim.v.foldend - vim.v.foldstart + 1), "Folded" })
            return chunks
        end

        -- The one thing that must be reachable from outside: 'foldtext' is a Vimscript expression
        package.loaded["LL.folds"] = { foldtext = foldtext }


        vim.keymap.set("n", "<Leader>zm", function()
            local sr, er = function_range_at_cursor()
            if not sr then
                vim.notify("Not inside a function", vim.log.levels.INFO)
                return
            end
            vim.cmd(("%d,%dfold"):format(sr + 1, er + 1))
        end, { desc = "Fold function" })
    end,
})

