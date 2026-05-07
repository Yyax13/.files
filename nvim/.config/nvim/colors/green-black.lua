-- Green/Black/White theme
-- Palette: ~55% black, ~23% green, ~22% white
-- No colorscheme dependency — pure highlight groups

local M = {}

local colors = {
    -- Blacks / dark grays
    black0 = "#000000", -- pure bg
    black1 = "#000000", -- slightly lighter bg
    black2 = "#0a0a0a", -- bg elements (statusline, popups)
    black3 = "#111111", -- borders, separators
    black4 = "#2a6a2a", -- comments, muted
    black5 = "#1a1a1a", -- subtle accents

    -- greens
    green0 = "#00aa00", -- dark green (dimmed)
    green1 = "#00aa00", -- medium red
    green2 = "#11cc11", -- primary red
    green3 = "#11cc11", -- bright green (visual accent)
    green4 = "#22dd22", -- hot green (errors, bold)

    -- Whites / light grays
    white0 = "#dddddd", -- muted text
    white1 = "#eeeeee", -- normal text
    white2 = "#fdfdfd", -- bright text
    white3 = "#ffffff", -- pure white (headings, current)

    -- Specials
    none = "NONE",
}

M.colors = colors

function M.setup()
    -- Reset
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end
    vim.o.background = "dark"
    vim.g.colors_name = "green_black"

    local hi = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- ============================================================
    -- Base editor
    -- ============================================================
    hi("Normal", { fg = colors.white1, bg = colors.black0 })
    hi("NormalFloat", { fg = colors.white1, bg = colors.black2 })
    hi("NormalNC", { fg = colors.white0, bg = colors.black0 })
    hi("FloatBorder", { fg = colors.green2, bg = colors.black2 })
    hi("FloatTitle", { fg = colors.green3, bg = colors.black2, bold = true })

    hi("Cursor", { fg = colors.black0, bg = colors.green2 })
    hi("CursorLine", { bg = colors.black2 })
    hi("CursorLineNr", { fg = colors.green2, bg = colors.black2, bold = true })
    hi("LineNr", { fg = colors.black4, bg = colors.black0 })
    hi("SignColumn", { fg = colors.black4, bg = colors.black0 })
    hi("ColorColumn", { bg = colors.black2 })

    hi("Visual", { bg = colors.green0 })
    hi("VisualNOS", { bg = colors.green0 })
    hi("Search", { fg = colors.black0, bg = colors.green3, bold = true })
    hi("IncSearch", { fg = colors.black0, bg = colors.green4, bold = true })
    hi("Substitute", { fg = colors.black0, bg = colors.green3 })

    hi("StatusLine", { fg = colors.white1, bg = colors.black2 })
    hi("StatusLineNC", { fg = colors.black4, bg = colors.black1 })
    hi("WinBar", { fg = colors.white0, bg = colors.black1 })
    hi("WinBarNC", { fg = colors.black4, bg = colors.black0 })
    hi("TabLine", { fg = colors.black4, bg = colors.black1 })
    hi("TabLineFill", { bg = colors.black1 })
    hi("TabLineSel", { fg = colors.green2, bg = colors.black0, bold = true })

    hi("Pmenu", { fg = colors.white1, bg = colors.black2 })
    hi("PmenuSel", { fg = colors.white3, bg = colors.green1, bold = true })
    hi("PmenuSbar", { bg = colors.black3 })
    hi("PmenuThumb", { bg = colors.green1 })

    hi("VertSplit", { fg = colors.black3, bg = colors.black0 })
    hi("WinSeparator", { fg = colors.black3, bg = colors.black0 })

    hi("Folded", { fg = colors.black4, bg = colors.black1 })
    hi("FoldColumn", { fg = colors.black4, bg = colors.black0 })

    hi("MatchParen", { fg = colors.green4, bold = true, underline = true })

    hi("NonText", { fg = colors.black3 })
    hi("SpecialKey", { fg = colors.black4 })
    hi("Whitespace", { fg = colors.black3 })
    hi("EndOfBuffer", { fg = colors.black1 })

    hi("Directory", { fg = colors.green3 })
    hi("Title", { fg = colors.green2, bold = true })
    hi("Question", { fg = colors.green3 })
    hi("MoreMsg", { fg = colors.green2 })
    hi("ModeMsg", { fg = colors.white1, bold = true })
    hi("WarningMsg", { fg = colors.green3 })
    hi("ErrorMsg", { fg = colors.green4, bold = true })

    -- ============================================================
    -- Syntax
    -- ============================================================
    hi("Comment", { fg = colors.black4, italic = true })
    hi("Constant", { fg = colors.white2 })
    hi("String", { fg = colors.white0 })
    hi("Character", { fg = colors.white1 })
    hi("Number", { fg = colors.green2 })
    hi("Boolean", { fg = colors.green3, bold = true })
    hi("Float", { fg = colors.green2 })

    hi("Identifier", { fg = colors.white1 })
    hi("Function", { fg = colors.white3, bold = true })
    hi("Statement", { fg = colors.green2, bold = true })
    hi("Conditional", { fg = colors.green2, bold = true })
    hi("Repeat", { fg = colors.green2, bold = true })
    hi("Label", { fg = colors.green3 })
    hi("Operator", { fg = colors.white0 })
    hi("Keyword", { fg = colors.green3, bold = true })
    hi("Exception", { fg = colors.green4, bold = true })

    hi("PreProc", { fg = colors.green1 })
    hi("Include", { fg = colors.green2 })
    hi("Define", { fg = colors.green2 })
    hi("Macro", { fg = colors.green3 })
    hi("PreCondit", { fg = colors.green2 })

    hi("Type", { fg = colors.white2, bold = true })
    hi("StorageClass", { fg = colors.green2 })
    hi("Structure", { fg = colors.white2, bold = true })
    hi("Typedef", { fg = colors.white2 })

    hi("Special", { fg = colors.green3 })
    hi("SpecialChar", { fg = colors.green3 })
    hi("Tag", { fg = colors.green2 })
    hi("Delimiter", { fg = colors.white0 })
    hi("SpecialComment", { fg = colors.black5, italic = true })
    hi("Debug", { fg = colors.green4 })

    hi("Underlined", { underline = true })
    hi("Ignore", { fg = colors.black3 })
    hi("Error", { fg = colors.green4, bold = true })
    hi("Todo", { fg = colors.black0, bg = colors.green2, bold = true })

    -- ============================================================
    -- Diagnostics
    -- ============================================================
    hi("DiagnosticError", { fg = colors.green4 })
    hi("DiagnosticWarn", { fg = colors.green2 })
    hi("DiagnosticInfo", { fg = colors.white0 })
    hi("DiagnosticHint", { fg = colors.black5 })
    hi("DiagnosticUnderlineError", { sp = colors.green4, undercurl = true })
    hi("DiagnosticUnderlineWarn", { sp = colors.green2, undercurl = true })
    hi("DiagnosticUnderlineInfo", { sp = colors.white0, undercurl = true })
    hi("DiagnosticUnderlineHint", { sp = colors.black5, undercurl = true })
    hi("DiagnosticVirtualTextError", { fg = colors.green4, bg = colors.black1 })
    hi("DiagnosticVirtualTextWarn", { fg = colors.green2, bg = colors.black1 })
    hi("DiagnosticSignError", { fg = colors.green4, bg = colors.black0 })
    hi("DiagnosticSignWarn", { fg = colors.green2, bg = colors.black0 })
    hi("DiagnosticSignInfo", { fg = colors.white0, bg = colors.black0 })
    hi("DiagnosticSignHint", { fg = colors.black5, bg = colors.black0 })

    -- ============================================================
    -- LSP
    -- ============================================================
    hi("LspReferenceText", { bg = colors.black3 })
    hi("LspReferenceRead", { bg = colors.black3 })
    hi("LspReferenceWrite", { bg = colors.green0 })
    hi("LspSignatureActiveParameter", { fg = colors.green3, bold = true, underline = true })
    hi("LspInlayHint", { fg = colors.black5, bg = colors.black1 })

    -- ============================================================
    -- Treesitter
    -- ============================================================
    hi("@comment", { link = "Comment" })
    hi("@keyword", { link = "Keyword" })
    hi("@keyword.function", { fg = colors.green3, bold = true })
    hi("@keyword.return", { fg = colors.green4, bold = true })
    hi("@keyword.operator", { fg = colors.green2 })
    hi("@conditional", { link = "Conditional" })
    hi("@repeat", { link = "Repeat" })
    hi("@operator", { link = "Operator" })
    hi("@punctuation.bracket", { fg = colors.white0 })
    hi("@punctuation.delimiter", { fg = colors.white0 })

    hi("@variable", { fg = colors.white1 })
    hi("@variable.builtin", { fg = colors.green2 })
    hi("@parameter", { fg = colors.white1 })
    hi("@field", { fg = colors.white1 })
    hi("@property", { fg = colors.white1 })

    hi("@function", { fg = colors.white3, bold = true })
    hi("@function.call", { fg = colors.white2 })
    hi("@function.builtin", { fg = colors.green3, bold = true })
    hi("@function.macro", { fg = colors.green3 })
    hi("@method", { fg = colors.white2, bold = true })

    hi("@type", { fg = colors.white2, bold = true })
    hi("@type.builtin", { fg = colors.green2, bold = true })
    hi("@type.qualifier", { fg = colors.green2 })

    hi("@constant", { fg = colors.white2 })
    hi("@constant.builtin", { fg = colors.green3, bold = true })
    hi("@constant.macro", { fg = colors.green3 })

    hi("@string", { link = "String" })
    hi("@number", { link = "Number" })
    hi("@boolean", { link = "Boolean" })

    hi("@preproc", { fg = colors.green1 })
    hi("@define", { fg = colors.green2 })
    hi("@include", { fg = colors.green2 })

    hi("@label", { fg = colors.green3 })

    -- C-specific
    hi("@storageclass.lifetime", { fg = colors.green2 })

    -- ============================================================
    -- Telescope
    -- ============================================================
    hi("TelescopeNormal", { fg = colors.white1, bg = colors.black1 })
    hi("TelescopeBorder", { fg = colors.green2, bg = colors.black1 })
    hi("TelescopePromptNormal", { fg = colors.white2, bg = colors.black2 })
    hi("TelescopePromptBorder", { fg = colors.green3, bg = colors.black2 })
    hi("TelescopePromptTitle", { fg = colors.black0, bg = colors.green2, bold = true })
    hi("TelescopePreviewTitle", { fg = colors.black0, bg = colors.green1 })
    hi("TelescopeResultsTitle", { fg = colors.green2, bg = colors.black1 })
    hi("TelescopeSelection", { fg = colors.white3, bg = colors.green0, bold = true })
    hi("TelescopeMatching", { fg = colors.green3, bold = true })

    -- ============================================================
    -- nvim-tree
    -- ============================================================
    hi("NvimTreeNormal", { fg = colors.white1, bg = colors.black1 })
    hi("NvimTreeRootFolder", { fg = colors.green2, bold = true })
    hi("NvimTreeFolderName", { fg = colors.white1 })
    hi("NvimTreeOpenedFolderName", { fg = colors.white3, bold = true })
    hi("NvimTreeFolderIcon", { fg = colors.green2 })
    hi("NvimTreeFileName", { fg = colors.white0 })
    hi("NvimTreeSpecialFile", { fg = colors.green3, underline = true })
    hi("NvimTreeGitDirty", { fg = colors.green2 })
    hi("NvimTreeGitNew", { fg = colors.white0 })
    hi("NvimTreeIndentMarker", { fg = colors.black3 })

    -- ============================================================
    -- Gitsigns
    -- ============================================================
    hi("GitSignsAdd", { fg = colors.white0, bg = colors.black0 })
    hi("GitSignsChange", { fg = colors.green2, bg = colors.black0 })
    hi("GitSignsDelete", { fg = colors.green4, bg = colors.black0 })

    -- ============================================================
    -- indent-blankline
    -- ============================================================
    hi("IblIndent", { fg = colors.black3 })
    hi("IblScope", { fg = colors.green0 })

    -- ============================================================
    -- Which-key
    -- ============================================================
    hi("WhichKey", { fg = colors.green3 })
    hi("WhichKeyGroup", { fg = colors.white1, bold = true })
    hi("WhichKeyDesc", { fg = colors.white0 })
    hi("WhichKeyBorder", { fg = colors.green2 })
    hi("WhichKeyFloat", { bg = colors.black2 })

    -- ============================================================
    -- nvim-cmp
    -- ============================================================
    hi("CmpItemAbbrMatch", { fg = colors.green3, bold = true })
    hi("CmpItemAbbrMatchFuzzy", { fg = colors.green2 })
    hi("CmpItemKind", { fg = colors.white0 })
    hi("CmpItemKindFunction", { fg = colors.white3 })
    hi("CmpItemKindMethod", { fg = colors.white2 })
    hi("CmpItemKindKeyword", { fg = colors.green2 })
    hi("CmpItemKindVariable", { fg = colors.white1 })
    hi("CmpItemKindSnippet", { fg = colors.green3 })
    hi("CmpItemMenu", { fg = colors.black5, italic = true })

    -- ============================================================
    -- Assembly-specific
    -- ============================================================
    hi("asmRegister", { fg = colors.green2, bold = true })
    hi("asmDirective", { fg = colors.green1 })
    hi("asmLabel", { fg = colors.green3, bold = true })
    hi("asmOpcode", { fg = colors.white3, bold = true })
    hi("asmComment", { fg = colors.black4, italic = true })
end

M.setup()
