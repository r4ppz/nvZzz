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
      url = "https://openrouter.ai/api/v1/chat/completions",
      api_key = "OPENROUTER_API_KEY",
      models = {
        { id = "openrouter/free", name = "Free Models Router (auto)", streaming = true },
        { id = "openai/gpt-oss-120b:free", name = "OpenAI: gpt-oss-120b (free)", streaming = true },
        { id = "openai/gpt-oss-20b:free", name = "OpenAI: gpt-oss-20b (free)", streaming = true },
        {
          id = "google/gemma-4-31b-it:free",
          name = "Google: Gemma 4 31B (free)",
          streaming = true,
        },
        {
          id = "google/gemma-4-26b-a4b-it:free",
          name = "Google: Gemma 4 26B A4B (free)",
          streaming = true,
        },
        {
          id = "google/lyria-3-pro-preview",
          name = "Google: Lyria 3 Pro Preview",
          streaming = true,
        },
        {
          id = "google/lyria-3-clip-preview",
          name = "Google: Lyria 3 Clip Preview",
          streaming = true,
        },
        {
          id = "meta-llama/llama-3.3-70b-instruct:free",
          name = "Meta: Llama 3.3 70B Instruct (free)",
          streaming = true,
        },
        {
          id = "meta-llama/llama-3.2-3b-instruct:free",
          name = "Meta: Llama 3.2 3B Instruct (free)",
          streaming = true,
        },
        {
          id = "qwen/qwen3-next-80b-a3b-instruct:free",
          name = "Qwen: Qwen3 Next 80B A3B Instruct (free)",
          streaming = true,
        },
        {
          id = "qwen/qwen3-coder:free",
          name = "Qwen: Qwen3 Coder 480B A35B (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-3-super-120b-a12b:free",
          name = "NVIDIA: Nemotron 3 Super (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-3-ultra-550b-a55b:free",
          name = "NVIDIA: Nemotron 3 Ultra (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free",
          name = "NVIDIA: Nemotron 3 Nano Omni (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-3-nano-30b-a3b:free",
          name = "NVIDIA: Nemotron 3 Nano 30B A3B (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-nano-12b-v2-vl:free",
          name = "NVIDIA: Nemotron Nano 12B 2 VL (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-nano-9b-v2:free",
          name = "NVIDIA: Nemotron Nano 9B V2 (free)",
          streaming = true,
        },
        {
          id = "nvidia/nemotron-3.5-content-safety:free",
          name = "NVIDIA: Nemotron 3.5 Content Safety (free)",
          streaming = true,
        },
      },
    }, builtin),

    freetheai = define({
      url = "https://api.freetheai.xyz/v1/chat/completions",
      api_key = "FREETHEAI_API_KEY",
      models = {
        { id = "opc/deepseek-v4-flash-free", name = "DeepSeek V4 Flash (free)", streaming = true },
        { id = "opc/mimo-v2.5-free", name = "Mimo V2.5 (free)", streaming = true },
        { id = "opc/nemotron-3-ultra-free", name = "Nemotron 3 Ultra (free)", streaming = true },
        { id = "opc/north-mini-code-free", name = "North Mini Code (free)", streaming = true },
        { id = "opc/big-pickle", name = "Big Pickle (free)", streaming = true },
        { id = "kai/openrouter/free", name = "Free Router (auto)", streaming = true },
        { id = "kai/kilo-auto/free", name = "Kilo Auto (free)", streaming = true },
        {
          id = "kai/nvidia/nemotron-3-super-120b-a12b:free",
          name = "Nemotron 3 Super 120B (free)",
          streaming = true,
        },
        {
          id = "kai/nvidia/nemotron-3-ultra-550b-a55b:free",
          name = "Nemotron 3 Ultra 550B (free)",
          streaming = true,
        },
        {
          id = "kai/nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free",
          name = "Nemotron 3 Nano Omni (free)",
          streaming = true,
        },
        {
          id = "kai/nvidia/nemotron-3.5-content-safety:free",
          name = "Nemotron 3.5 Content Safety (free)",
          streaming = true,
        },
        {
          id = "kai/cohere/north-mini-code:free",
          name = "Cohere North Mini Code (free)",
          streaming = true,
        },
        {
          id = "kai/stepfun/step-3.7-flash:free",
          name = "Step 3.7 Flash (free)",
          streaming = true,
        },
        { id = "kai/poolside/laguna-xs-2.1:free", name = "Laguna XS 2.1 (free)", streaming = true },
        { id = "kai/poolside/laguna-xs.2:free", name = "Laguna XS.2 (free)", streaming = true },
        { id = "kai/poolside/laguna-m.1:free", name = "Laguna M.1 (free)", streaming = true },
      },
    }, builtin),

    pollinations = define({
      url = "https://text.pollinations.ai/openai",
      models = {
        { id = "openai", name = "GPT-OSS 20B Reasoning LLM", streaming = true },
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
