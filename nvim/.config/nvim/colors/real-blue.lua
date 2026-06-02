-- blue/Black/White theme
-- Palette: ~55% black, ~23% blue, ~22% white
-- No colorscheme dependency — pure highlight groups

local M = {}

local colors = {
    -- Blacks / dark grays
    black0 = "#000000", -- pure bg
    black1 = "#000000", -- slightly lighter bg
    black2 = "#000000", -- bg elements (statusline, popups)
    black3 = "#000000", -- borders, separators
    black4 = "#2a2a6a", -- comments, muted
    black5 = "#0a0a0a", -- subtle accents

    -- blues
    blue0 = "#0000aa", -- dark blue (dimmed)
    blue1 = "#0000aa", -- medium blue
    blue2 = "#0000aa", -- primary blue
    blue3 = "#1111cc", -- bright blue (visual accent)
    blue4 = "#2222dd", -- hot blue (errors, bold)

    -- Whites / light grays
    white0 = "#ffffff", -- muted text
    white1 = "#ffffff", -- normal text
    white2 = "#ffffff", -- bright text
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
    vim.g.colors_name = "real-blue"

    local hi = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- ============================================================
    -- Base editor
    -- ============================================================
    hi("Normal", { fg = colors.white1, bg = colors.black0 })
    hi("NormalFloat", { fg = colors.white1, bg = colors.black2 })
    hi("NormalNC", { fg = colors.white0, bg = colors.black0 })
    hi("FloatBorder", { fg = colors.blue2, bg = colors.black2 })
    hi("FloatTitle", { fg = colors.blue3, bg = colors.black2, bold = true })

    hi("Cursor", { fg = colors.black0, bg = colors.blue2 })
    hi("CursorLine", { bg = colors.black2 })
    hi("CursorLineNr", { fg = colors.blue2, bg = colors.black2, bold = true })
    hi("LineNr", { fg = colors.black4, bg = colors.black0 })
    hi("SignColumn", { fg = colors.black4, bg = colors.black0 })
    hi("ColorColumn", { bg = colors.black2 })

    hi("Visual", { bg = colors.blue0 })
    hi("VisualNOS", { bg = colors.blue0 })
    hi("Search", { fg = colors.black0, bg = colors.blue3, bold = true })
    hi("IncSearch", { fg = colors.black0, bg = colors.blue4, bold = true })
    hi("Substitute", { fg = colors.black0, bg = colors.blue3 })

    hi("StatusLine", { fg = colors.white1, bg = colors.black2 })
    hi("StatusLineNC", { fg = colors.black4, bg = colors.black1 })
    hi("WinBar", { fg = colors.white0, bg = colors.black1 })
    hi("WinBarNC", { fg = colors.black4, bg = colors.black0 })
    hi("TabLine", { fg = colors.black4, bg = colors.black1 })
    hi("TabLineFill", { bg = colors.black1 })
    hi("TabLineSel", { fg = colors.blue2, bg = colors.black0, bold = true })

    hi("Pmenu", { fg = colors.white1, bg = colors.black2 })
    hi("PmenuSel", { fg = colors.white3, bg = colors.blue1, bold = true })
    hi("PmenuSbar", { bg = colors.black3 })
    hi("PmenuThumb", { bg = colors.blue1 })

    hi("VertSplit", { fg = colors.black3, bg = colors.black0 })
    hi("WinSeparator", { fg = colors.black3, bg = colors.black0 })

    hi("Folded", { fg = colors.black4, bg = colors.black1 })
    hi("FoldColumn", { fg = colors.black4, bg = colors.black0 })

    hi("MatchParen", { fg = colors.blue4, bold = true, underline = true })

    hi("NonText", { fg = colors.black3 })
    hi("SpecialKey", { fg = colors.black4 })
    hi("Whitespace", { fg = colors.black3 })
    hi("EndOfBuffer", { fg = colors.black1 })

    hi("Directory", { fg = colors.blue3 })
    hi("Title", { fg = colors.blue2, bold = true })
    hi("Question", { fg = colors.blue3 })
    hi("MoreMsg", { fg = colors.blue2 })
    hi("ModeMsg", { fg = colors.white1, bold = true })
    hi("WarningMsg", { fg = colors.blue3 })
    hi("ErrorMsg", { fg = colors.blue4, bold = true })

    -- ============================================================
    -- Syntax
    -- ============================================================
    hi("Comment", { fg = colors.black4, italic = true })
    hi("Constant", { fg = colors.white2 })
    hi("String", { fg = colors.white0 })
    hi("Character", { fg = colors.white1 })
    hi("Number", { fg = colors.blue2 })
    hi("Boolean", { fg = colors.blue3, bold = true })
    hi("Float", { fg = colors.blue2 })

    hi("Identifier", { fg = colors.white1 })
    hi("Function", { fg = colors.white3, bold = true })
    hi("Statement", { fg = colors.blue2, bold = true })
    hi("Conditional", { fg = colors.blue2, bold = true })
    hi("Repeat", { fg = colors.blue2, bold = true })
    hi("Label", { fg = colors.blue3 })
    hi("Operator", { fg = colors.white0 })
    hi("Keyword", { fg = colors.blue3, bold = true })
    hi("Exception", { fg = colors.blue4, bold = true })

    hi("PreProc", { fg = colors.blue1 })
    hi("Include", { fg = colors.blue2 })
    hi("Define", { fg = colors.blue2 })
    hi("Macro", { fg = colors.blue3 })
    hi("PreCondit", { fg = colors.blue2 })

    hi("Type", { fg = colors.white2, bold = true })
    hi("StorageClass", { fg = colors.blue2 })
    hi("Structure", { fg = colors.white2, bold = true })
    hi("Typedef", { fg = colors.white2 })

    hi("Special", { fg = colors.blue3 })
    hi("SpecialChar", { fg = colors.blue3 })
    hi("Tag", { fg = colors.blue2 })
    hi("Delimiter", { fg = colors.white0 })
    hi("SpecialComment", { fg = colors.black5, italic = true })
    hi("Debug", { fg = colors.blue4 })

    hi("Underlined", { underline = true })
    hi("Ignore", { fg = colors.black3 })
    hi("Error", { fg = colors.blue4, bold = true })
    hi("Todo", { fg = colors.black0, bg = colors.blue2, bold = true })

    -- ============================================================
    -- Diagnostics
    -- ============================================================
    hi("DiagnosticError", { fg = colors.blue4 })
    hi("DiagnosticWarn", { fg = colors.blue2 })
    hi("DiagnosticInfo", { fg = colors.white0 })
    hi("DiagnosticHint", { fg = colors.black5 })
    hi("DiagnosticUnderlineError", { sp = colors.blue4, undercurl = true })
    hi("DiagnosticUnderlineWarn", { sp = colors.blue2, undercurl = true })
    hi("DiagnosticUnderlineInfo", { sp = colors.white0, undercurl = true })
    hi("DiagnosticUnderlineHint", { sp = colors.black5, undercurl = true })
    hi("DiagnosticVirtualTextError", { fg = colors.blue4, bg = colors.black1 })
    hi("DiagnosticVirtualTextWarn", { fg = colors.blue2, bg = colors.black1 })
    hi("DiagnosticSignError", { fg = colors.blue4, bg = colors.black0 })
    hi("DiagnosticSignWarn", { fg = colors.blue2, bg = colors.black0 })
    hi("DiagnosticSignInfo", { fg = colors.white0, bg = colors.black0 })
    hi("DiagnosticSignHint", { fg = colors.black5, bg = colors.black0 })

    -- ============================================================
    -- LSP
    -- ============================================================
    hi("LspReferenceText", { bg = colors.black3 })
    hi("LspReferenceRead", { bg = colors.black3 })
    hi("LspReferenceWrite", { bg = colors.blue0 })
    hi("LspSignatureActiveParameter", { fg = colors.blue3, bold = true, underline = true })
    hi("LspInlayHint", { fg = colors.black5, bg = colors.black1 })

    -- ============================================================
    -- Treesitter
    -- ============================================================
    hi("@comment", { link = "Comment" })
    hi("@keyword", { link = "Keyword" })
    hi("@keyword.function", { fg = colors.blue3, bold = true })
    hi("@keyword.return", { fg = colors.blue4, bold = true })
    hi("@keyword.operator", { fg = colors.blue2 })
    hi("@conditional", { link = "Conditional" })
    hi("@repeat", { link = "Repeat" })
    hi("@operator", { link = "Operator" })
    hi("@punctuation.bracket", { fg = colors.white0 })
    hi("@punctuation.delimiter", { fg = colors.white0 })

    hi("@variable", { fg = colors.white1 })
    hi("@variable.builtin", { fg = colors.blue2 })
    hi("@parameter", { fg = colors.white1 })
    hi("@field", { fg = colors.white1 })
    hi("@property", { fg = colors.white1 })

    hi("@function", { fg = colors.white3, bold = true })
    hi("@function.call", { fg = colors.white2 })
    hi("@function.builtin", { fg = colors.blue3, bold = true })
    hi("@function.macro", { fg = colors.blue3 })
    hi("@method", { fg = colors.white2, bold = true })

    hi("@type", { fg = colors.white2, bold = true })
    hi("@type.builtin", { fg = colors.blue2, bold = true })
    hi("@type.qualifier", { fg = colors.blue2 })

    hi("@constant", { fg = colors.white2 })
    hi("@constant.builtin", { fg = colors.blue3, bold = true })
    hi("@constant.macro", { fg = colors.blue3 })

    hi("@string", { link = "String" })
    hi("@number", { link = "Number" })
    hi("@boolean", { link = "Boolean" })

    hi("@preproc", { fg = colors.blue1 })
    hi("@define", { fg = colors.blue2 })
    hi("@include", { fg = colors.blue2 })

    hi("@label", { fg = colors.blue3 })

    -- C-specific
    hi("@storageclass.lifetime", { fg = colors.blue2 })

    -- ============================================================
    -- Telescope
    -- ============================================================
    hi("TelescopeNormal", { fg = colors.white1, bg = colors.black1 })
    hi("TelescopeBorder", { fg = colors.blue2, bg = colors.black1 })
    hi("TelescopePromptNormal", { fg = colors.white2, bg = colors.black2 })
    hi("TelescopePromptBorder", { fg = colors.blue3, bg = colors.black2 })
    hi("TelescopePromptTitle", { fg = colors.black0, bg = colors.blue2, bold = true })
    hi("TelescopePreviewTitle", { fg = colors.black0, bg = colors.blue1 })
    hi("TelescopeResultsTitle", { fg = colors.blue2, bg = colors.black1 })
    hi("TelescopeSelection", { fg = colors.white3, bg = colors.blue0, bold = true })
    hi("TelescopeMatching", { fg = colors.blue3, bold = true })

    -- ============================================================
    -- nvim-tree
    -- ============================================================
    hi("NvimTreeNormal", { fg = colors.white1, bg = colors.black1 })
    hi("NvimTreeRootFolder", { fg = colors.blue2, bold = true })
    hi("NvimTreeFolderName", { fg = colors.white1 })
    hi("NvimTreeOpenedFolderName", { fg = colors.white3, bold = true })
    hi("NvimTreeFolderIcon", { fg = colors.blue2 })
    hi("NvimTreeFileName", { fg = colors.white0 })
    hi("NvimTreeSpecialFile", { fg = colors.blue3, underline = true })
    hi("NvimTreeGitDirty", { fg = colors.blue2 })
    hi("NvimTreeGitNew", { fg = colors.white0 })
    hi("NvimTreeIndentMarker", { fg = colors.black3 })

    -- ============================================================
    -- Gitsigns
    -- ============================================================
    hi("GitSignsAdd", { fg = colors.white0, bg = colors.black0 })
    hi("GitSignsChange", { fg = colors.blue2, bg = colors.black0 })
    hi("GitSignsDelete", { fg = colors.blue4, bg = colors.black0 })

    -- ============================================================
    -- indent-blankline
    -- ============================================================
    hi("IblIndent", { fg = colors.black3 })
    hi("IblScope", { fg = colors.blue0 })

    -- ============================================================
    -- Which-key
    -- ============================================================
    hi("WhichKey", { fg = colors.blue3 })
    hi("WhichKeyGroup", { fg = colors.white1, bold = true })
    hi("WhichKeyDesc", { fg = colors.white0 })
    hi("WhichKeyBorder", { fg = colors.blue2 })
    hi("WhichKeyFloat", { bg = colors.black2 })

    -- ============================================================
    -- nvim-cmp
    -- ============================================================
    hi("CmpItemAbbrMatch", { fg = colors.blue3, bold = true })
    hi("CmpItemAbbrMatchFuzzy", { fg = colors.blue2 })
    hi("CmpItemKind", { fg = colors.white0 })
    hi("CmpItemKindFunction", { fg = colors.white3 })
    hi("CmpItemKindMethod", { fg = colors.white2 })
    hi("CmpItemKindKeyword", { fg = colors.blue2 })
    hi("CmpItemKindVariable", { fg = colors.white1 })
    hi("CmpItemKindSnippet", { fg = colors.blue3 })
    hi("CmpItemMenu", { fg = colors.black5, italic = true })

    -- ============================================================
    -- Assembly-specific
    -- ============================================================
    hi("asmRegister", { fg = colors.blue2, bold = true })
    hi("asmDirective", { fg = colors.blue1 })
    hi("asmLabel", { fg = colors.blue3, bold = true })
    hi("asmOpcode", { fg = colors.white3, bold = true })
    hi("asmComment", { fg = colors.black4, italic = true })
end

M.setup()
