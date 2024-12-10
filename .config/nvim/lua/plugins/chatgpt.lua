-- local session = vim.fn.expand("$BW_SESSION")
local bwSession = os.getenv("BW_SESSION")
local checkBWSession = function()
  return bwSession ~= nil and bwSession ~= ""
end

return {
  "jackMort/ChatGPT.nvim",
  cond = checkBWSession(),
  config = function()
    require("chatgpt").setup({
      -- this config assumes you have OPENAI_API_KEY environment variable set
      api_key_cmd = os.getenv("OPENAI_API_KEY"),
      openai_params = {
        -- NOTE: model can be a function returning the model name
        -- this is useful if you want to change the model on the fly
        -- using commands
        -- Example:
        -- model = function()
        --     if some_condition() then
        --         return "gpt-4-1106-preview"
        --     else
        --         return "gpt-3.5-turbo"
        --     end
        -- end,
        model = "gpt-4-1106-preview",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4095,
        temperature = 0.2,
        top_p = 0.1,
        n = 1,
      },
    })
    local wk = require("which-key")
    wk.add({
      { "<leader>i", group = "ChatGPT" }, -- group
      { "<leader>ii", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      {
        -- Nested mappings are allowed and can be added in any order
        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        mode = { "v" }, -- NORMAL and VISUAL mode
        { "<leader>ie", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
        { "<leader>ig", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
        { "<leader>it", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
        { "<leader>ik", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
        { "<leader>id", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
        { "<leader>ia", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
        { "<leader>io", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
        { "<leader>is", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
        { "<leader>if", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
        { "<leader>ix", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
        { "<leader>ir", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
        { "<leader>il", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
