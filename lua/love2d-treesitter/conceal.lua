local M = {}

M.setConceal = function(config)
    local charLove = config.conceal.love
    local charDot = config.conceal.love_dot

    vim.g.love2d_treesitter_conceal = true

    if charLove == false and charDot == false then
        vim.g.love2d_treesitter_conceal = false
        return
    end

    local lang = "lua"
    local hl = "highlights"

    local query_to_add = ";; extends\n"
    local has_content = false
    if charDot then
        local concealDot = string.format([[(#set! @punctuation.dot.love conceal "%s")]], charDot)

        query_to_add = query_to_add .. string.format([[
([
  (function_call
    (dot_index_expression
      table: (identifier) @variable.global.love
      "." @punctuation.dot.love))
  (function_declaration
    (dot_index_expression
      table: (identifier) @variable.global.love
      "." @punctuation.dot.love))
  (dot_index_expression
    table: (identifier) @variable.global.love
    "." @punctuation.dot.love)
]
  (#eq? @variable.global.love "love")
  %s
  (#set! priority 160))
]], concealDot)
        has_content = true
    end

    if charLove then
        local concealLove = string.format([[(#set! @variable.global.love conceal "%s")]], charLove)
        query_to_add = query_to_add .. string.format([[
([
  (function_call
    (dot_index_expression
      table: (identifier) @variable.global.love))
  (function_declaration
    (dot_index_expression
      table: (identifier) @variable.global.love))
  (assignment_statement
    (variable_list
      name: (identifier) @variable.global.love))
  (dot_index_expression
    table: (identifier) @variable.global.love)
  (return_statement
    (expression_list
      (identifier) @variable.global.love))
]
  (#eq? @variable.global.love "love")
  %s
  (#set! priority 160))
]], concealLove)
        has_content = true
    end

    if not has_content then
        return
    end

    vim.treesitter.query.set(lang, hl, query_to_add)
end

return M
