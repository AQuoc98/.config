return {
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "deepseek-r1:14b", -- The default model to use.
      quit_map = "q", -- set keymap to close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
      host = "localhost", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = false, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
      show_model = false, -- Displays which model you are using at the beginning of your chat session.
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

      prompts = {
        Generate_Code = {
          prompt = "Based on the following description, generate the appropriate code:\n\nDescription: $input\n\nExisting context:\n```$filetype\n$text\n```",
          replace = false,
          model = "qwen2.5-coder:14b",
        },
        Review_Code = {
          prompt = "Analyze the following code and provide clear, concise improvement suggestions:\n```$filetype\n$text\n```\nFocus on efficiency, readability, and best practices.",
          replace = false,
          model = "qwen2.5-coder:14b",
        },
        Generate = {
          prompt = "Generate a response based on the following input:\n$input",
          replace = false,
        },
        Chat = {
          prompt = "You are an intelligent assistant. Respond naturally to the following message:\n$input",
        },
        Summarize = {
          prompt = "Provide a clear and concise summary of the following text:\n$text",
        },
        Ask = {
          prompt = "Answer the following query based on the given context:\n\nQuery: $input\n\nContext:\n$text",
        },
        Change = {
          prompt = "Modify the following text based on this instruction: $input\n\nText:\n$text\n\nOutput the final modified text without additional formatting.",
          replace = false,
        },
        Enhance_Grammar_Spelling = {
          prompt = "Improve the grammar and spelling of the following text. Only return the corrected text without additional formatting:\n$text",
          replace = false,
        },
        Enhance_Wording = {
          prompt = "Refine the following text for better clarity and readability. Only return the improved text without extra formatting:\n$text",
          replace = false,
        },
        Make_Concise = {
          prompt = "Rewrite the following text to be as simple and concise as possible while retaining meaning. Only return the revised text:\n$text",
          replace = false,
        },
        Make_List = {
          prompt = "Convert the following text into a well-structured Markdown list:\n$text",
          replace = false,
        },
        Make_Table = {
          prompt = "Convert the following text into a properly formatted Markdown table:\n$text",
          replace = false,
        },
        Enhance_Code = {
          prompt = "Optimize and improve the following code. Focus on efficiency, readability, and best practices. Return only the updated code in the format:\n```$filetype\n...\n```\n\n```$filetype\n$text\n```",
          replace = false,
          extract = "```$filetype\n(.-)```",
          model = "qwen2.5-coder:14b",
        },
        Change_Code = {
          prompt = "Modify the following code according to this instruction: $input\n\nCode:\n```$filetype\n$text\n```\n\nReturn only the modified code in the format:\n```$filetype\n...\n```",
          replace = false,
          extract = "```$filetype\n(.-)```",
          model = "qwen2.5-coder:14b",
        },
        Translate = {
          prompt = "Please translate the following passage:\n$text\n from $input for me. Kindly provide several different versions of the translation. You must need to return the translated text with correct grammar and appropriate vocabulary",
          replace = false,
          model = "deepseek-r1:14b",
        },
        Write_Novel = {
          prompt = "Please help me write a novel or story based on the $input. Using the following context:$text. Please begin or continue to describe this story in an engaging way that captivates readers and has logical, cohesive content",
          replace = false,
          model = "llava:13b",
        },
      },
    },
  },
}
