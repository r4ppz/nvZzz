local M = {}

local function no_reasoning(fn)
  return function(output, opts)
    local result = fn(output, opts)
    result.reasoning = nil
    return result
  end
end

local function define(spec, builtin)
  local input_fn = spec.prepare_input or builtin.copilot.prepare_input
  local output_fn = spec.prepare_output or builtin.copilot.prepare_output

  return {
    get_url = function()
      return spec.url
    end,
    get_headers = function()
      local headers = { ["Content-Type"] = "application/json" }
      if spec.api_key then
        local key = os.getenv(spec.api_key)
        if key then
          headers["Authorization"] = "Bearer " .. key
        end
      end
      return headers
    end,
    get_models = function()
      return spec.models
    end,
    prepare_input = input_fn,
    prepare_output = no_reasoning(output_fn),
  }
end

function M.setup()
  local builtin = require("CopilotChat.config.providers")

  return {
    ollama = define({
      url = "http://localhost:11434/v1/chat/completions",
      models = {
        { id = "llama3.2:3b", name = "Llama 3.2 3B", streaming = true },
        { id = "llama3.2:1b", name = "Llama 3.2 1B", streaming = true },
        { id = "lfm2.5:latest", name = "LFM 2.5 Latest", streaming = true },
        { id = "qwen3.5:latest", name = "Qwen 3.5 Latest", streaming = true },
        { id = "gemma4:latest", name = "Gemma 4 Latest", streaming = true },
        { id = "gemma4:e2b", name = "Gemma 4 E2B", streaming = true },
        { id = "qwen3:4b", name = "Qwen3 4B", streaming = true },
      },
    }, builtin),

    openrouter = define({
      -- models.py https://openrouter.ai/api/v1/ $OPENROUTER_API_KEY --free
      url = "https://openrouter.ai/api/v1/chat/completions",
      api_key = "OPENROUTER_API_KEY",
      models = {
        {
          id = "openrouter/free",
          name = "Free Models Router (auto)",
          streaming = true,
        },
        {
          id = "openai/gpt-oss-120b:free",
          name = "OpenAI: gpt-oss-120b (free)",
          streaming = true,
        },
        {
          id = "openai/gpt-oss-20b:free",
          name = "OpenAI: gpt-oss-20b (free)",
          streaming = true,
        },
      },
    }, builtin),

    google = define({
      -- models.py https://generativelanguage.googleapis.com/v1beta/openai/v1/ $GEMINI_API_KEY
      url = "https://generativelanguage.googleapis.com/v1beta/openai/v1/chat/completions",
      api_key = "GEMINI_API_KEY",
      models = {
        {
          id = "models/gemini-3.5-flash",
          name = "Gemini 3.5 Flash",
          streaming = true,
        },
        {
          id = "models/gemini-3.1-flash-lite",
          name = "Gemini 3.1 Flash Lite",
          streaming = true,
        },
        {
          id = "models/gemini-3-flash-preview",
          name = "Gemini 3 Flash Preview",
          streaming = true,
        },
        {
          id = "models/gemini-2.5-flash",
          name = "Gemini 2.5 Flash",
          streaming = true,
        },
        {
          id = "models/gemini-2.5-flash-lite",
          name = "Gemini 2.5 Flash Lite",
          streaming = true,
        },
        {
          id = "models/gemini-2.0-flash",
          name = "Gemini 2.0 Flash",
          streaming = true,
        },
        {
          id = "models/gemini-2.0-flash-lite",
          name = "Gemini 2.0 Flash Lite",
          streaming = true,
        },
      },
    }, builtin),

    freetheai = define({
      -- models.py https://api.freetheai.xyz/v1/ $FREETHEAI_API_KEY --free
      url = "https://api.freetheai.xyz/v1/chat/completions",
      api_key = "FREETHEAI_API_KEY",
      models = {
        {
          id = "opc/deepseek-v4-flash-free",
          name = "DeepSeek V4 Flash (free)",
          streaming = true,
        },
        {
          id = "opc/hy3-free",
          name = "Hy3 (free)",
          streaming = true,
        },
      },
    }, builtin),

    groq = define({
      -- models.py https://api.groq.com/openai/v1/ $GROQ_API_KEY
      url = "https://api.groq.com/openai/v1/chat/completions",
      api_key = "GROQ_API_KEY",
      models = {
        {
          id = "openai/gpt-oss-120b",
          name = "GPT-OSS 120b",
          streaming = true,
        },
        {
          id = "openai/gpt-oss-20b",
          name = "GPT OSS 20b",
          streaming = true,
        },
        {
          id = "qwen/qwen3.6-27b",
          name = "Qwen 3.6 27b",
          streaming = true,
        },
        {
          id = "llama-3.3-70b-versatile",
          name = "Llama 3.3 70b Versitile",
          streaming = true,
        },
        {
          id = "groq/compound",
          name = "Groq Compound",
          streaming = true,
        },
      },
    }, builtin),

    pollinations = define({
      url = "https://text.pollinations.ai/openai",
      models = {
        {
          id = "openai",
          name = "GPT-OSS 20B Reasoning LLM",
          streaming = true,
        },
      },
      prepare_input = function(inputs, opts)
        local body, extra = builtin.copilot.prepare_input(inputs, opts)
        if body.messages then
          body.messages = vim
            .iter(body.messages)
            :filter(function(m)
              return m.content ~= nil and m.content ~= ""
            end)
            :totable()
        end
        return body, extra
      end,
    }, builtin),

    copilot = {
      prepare_output = no_reasoning(builtin.copilot.prepare_output),
    },
  }
end

return M
