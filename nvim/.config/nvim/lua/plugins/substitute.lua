return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "s", substitute.operator, { desc = "[S]ubstitute with motion" })
    keymap.set("n", "ss", substitute.line, { desc = "[S]ub[S]titute line" })
    keymap.set("n", "S", substitute.eol, { desc = "[S]ubstitute to [E]nd of line" })
    keymap.set("x", "s", substitute.visual, { desc = "[S]ubstitute in [V]isual mode" })
  end,
}
