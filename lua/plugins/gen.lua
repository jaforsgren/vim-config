return {
  {
    "David-Kunz/gen.nvim",
    -- keys = {
    --   { "<Leader>g", ":Gen<CR>", desc = "Open Gen" }, -- Open Gen with a shortcut (leader key + g)
    -- },
    opts = {
      model = "mistral", -- The default model to use.
      quit_map = "q", -- set keymap to close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      accept_map = "< c-cr>", -- set keymap to replace the previous selection with the last result
      host = "localhost", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = false, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      file = false, -- Write the payload to a temporary file to keep the command short.
      hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      result_filetype = "markdown", -- Configure filetype of the result buffer
      debug = false, -- Prints errors and the command which is run.
    },
    config = function(_, opts)
      local gen = require("gen")
      gen.setup(opts)

      function gen.get_comment()
        local line = vim.api.nvim_get_current_line()
        local comment_pattern = "^%s*--%s*(.-)%s*$"
        local match = line:match(comment_pattern)
        return match or ""
      end

      gen.prompts["Elaborate text"] = {
        prompt = "Elaborate the following text:\n$text",
        replace = true,
      }
      gen.prompts["Fix_Code (replace)"] = {
        prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
      }

      gen.prompts["Fix_Code (suggest)"] = {
        prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      }

      gen.prompts["Refactor Code"] = {
        prompt = "Refactor the following code to make it more efficient and readable:\n$text",
      }

      gen.prompts["Code from Comment"] = {
        prompt = "As a pro programmer, implement this:\n" .. gen.get_comment() .. "\n$text",
        replace = true,
      }

      local wk = require("which-key")
      wk.add({
        { "<leader>cx", gen.select_model, desc = "(Gen) change model" },
        { "<leader>cc", "<cmd>Gen<cr>", desc = "(Gen) Toggle Chat" },
        { "<leader>cr", gen.retry, desc = "(Gen) Retry last prompt" },
        { "<leader>ca", gen.accept, desc = "(Gen) Accept and replace selection with response" },
      })
    end,
  },
}
