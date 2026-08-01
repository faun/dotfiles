-- :checkhealth config.ai — report how the per-machine AI tiers resolved and
-- what to change to get a different setup. See lua/config/ai.lua for the
-- resolution rules and local.sh.example for where to set the env vars.

local M = {}

local health = vim.health

local VALID_COMPLETION = { off = true, copilot = true, fireworks = true, ["local"] = true, auto = true }

local function env(name)
  local v = os.getenv(name)
  if v == nil or v == "" then
    return nil
  end
  return v
end

local function plugin_state(name)
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return nil
  end
  local plugin = lazy_config.plugins[name]
  if not plugin then
    return { in_spec = false }
  end
  return {
    in_spec = true,
    installed = plugin._.installed == true,
    loaded = plugin._.loaded ~= nil,
  }
end

local function check_completion(ai)
  health.start("Inline completion (ghost text)")

  local raw = env("NVIM_AI_COMPLETION")
  local tier = ai.completion()

  if raw and not VALID_COMPLETION[raw] then
    health.error(("NVIM_AI_COMPLETION=%s is not a recognized value; completion is disabled"):format(raw), {
      "Set NVIM_AI_COMPLETION to one of: off | copilot | fireworks | local | auto (in ~/.local.sh)",
    })
    return
  end

  health.info(("NVIM_AI_COMPLETION=%s -> resolved tier: %s"):format(raw or "(unset, defaults to auto)", tier))

  if raw and raw ~= "auto" and raw ~= tier then
    health.warn(
      ("requested tier '%s' was downgraded to '%s'"):format(raw, tier),
      raw == "fireworks" and { "Set FIREWORKS_API_KEY in ~/.local.sh" } or nil
    )
  end

  if (raw or "auto") == "auto" then
    local llama_up = ai.llama_server_up()
    health.info(
      ("auto detection: llama-server on 127.0.0.1:%d %s; FIREWORKS_API_KEY %s"):format(
        ai.llama_port,
        llama_up and "reachable" or "not reachable",
        env("FIREWORKS_API_KEY") and "set" or "unset"
      )
    )
  end

  if tier == "off" then
    health.ok("AI completion disabled on this machine")
    health.info("Enable it with NVIM_AI_COMPLETION=copilot|fireworks|local|auto in ~/.local.sh")
    return
  end

  if tier == "local" then
    if ai.llama_server_up() then
      health.ok(("llama-server reachable at %s"):format(ai.llama_endpoint()))
    else
      health.error("resolved tier is 'local' but llama-server is no longer reachable", {
        ("Start it, e.g.: llama-server -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF --port %d -ngl 99"):format(
          ai.llama_port
        ),
        "Or restart Neovim to let 'auto' pick another tier",
      })
    end
  elseif tier == "fireworks" then
    if env("FIREWORKS_API_KEY") then
      health.ok("FIREWORKS_API_KEY is set")
    else
      health.error("resolved tier is 'fireworks' but FIREWORKS_API_KEY is unset", {
        "Set FIREWORKS_API_KEY in ~/.local.sh",
      })
    end
    health.info(
      ("model: %s%s"):format(
        env("NVIM_AI_FIREWORKS_MODEL") or "accounts/fireworks/models/qwen2p5-coder-32b-instruct",
        env("NVIM_AI_FIREWORKS_MODEL") and " (from NVIM_AI_FIREWORKS_MODEL)"
          or " (default; override with NVIM_AI_FIREWORKS_MODEL)"
      )
    )
  end

  if tier == "local" or tier == "fireworks" then
    local minuet = plugin_state("minuet-ai.nvim")
    if minuet and not minuet.in_spec then
      health.error("minuet-ai.nvim is not in the plugin spec (unexpected for this tier)")
    elseif minuet and not minuet.installed then
      health.warn("minuet-ai.nvim is not installed yet", { "Run :Lazy install" })
    elseif minuet then
      health.ok(
        ("minuet-ai.nvim %s (accept <M-l>, accept line <M-;>, cycle <M-]>/<M-[>, dismiss <C-]>)"):format(
          minuet.loaded and "loaded" or "installed (loads on BufReadPre)"
        )
      )
    end
    health.info("Ghost text hides while the completion menu is open; <M-]> always requests one manually")
  end

  if tier == "copilot" then
    local copilot = plugin_state("copilot.lua")
    if copilot and copilot.loaded then
      local ok, status = pcall(function()
        return require("copilot.status").data
      end)
      if ok and status.status == "Error" then
        health.error(("copilot.lua loaded but reports: %s"):format(status.message or "error"), {
          "Run :Copilot auth to sign into GitHub",
        })
      elseif ok then
        health.ok(("copilot.lua loaded, status: %s"):format(status.status ~= "" and status.status or "idle"))
      else
        health.warn("copilot.lua loaded but status is unavailable")
      end
    elseif copilot and copilot.in_spec then
      health.warn("copilot.lua not loaded yet (loads on BufReadPost)", {
        "Open a file, then run :Copilot status",
      })
    else
      health.error("copilot.lua missing from the plugin spec")
    end
  end
end

local function check_nes(ai)
  health.start("Next Edit Suggestions (sidekick.nvim)")

  local raw = env("NVIM_AI_NES")
  if not ai.nes() then
    health.ok("NES disabled on this machine (NVIM_AI_NES=off)")
    health.info("Enable it by removing NVIM_AI_NES=off from ~/.local.sh (defaults to on)")
    return
  end

  health.info(("NVIM_AI_NES=%s -> enabled"):format(raw or "(unset, defaults to on)"))

  if vim.fn.has("nvim-0.11.2") ~= 1 then
    health.error("sidekick.nvim needs Neovim >= 0.11.2")
    return
  end

  local sidekick = plugin_state("sidekick.nvim")
  if sidekick and not sidekick.in_spec then
    health.error("sidekick.nvim is not in the plugin spec (unexpected while NES is on)")
  elseif sidekick and not sidekick.installed then
    health.warn("sidekick.nvim is not installed yet", { "Run :Lazy install" })
  elseif sidekick then
    health.ok(
      "sidekick.nvim "
        .. (sidekick.loaded and "loaded" or "installed")
        .. " (<Tab> in normal mode jumps to/applies an edit)"
    )
  end

  health.info("NES rides on Copilot's LSP: it needs copilot.lua enabled and a GitHub sign-in (:Copilot auth)")
end

local function check_assist(ai)
  health.start("Chat / inline edits (CodeCompanion)")

  local assist = ai.assist()
  if assist == "off" then
    health.ok("assist disabled on this machine")
    health.info("Enable it with NVIM_AI_ASSIST=codecompanion in ~/.local.sh")
    return
  end

  if assist ~= "codecompanion" then
    health.error(("NVIM_AI_ASSIST=%s is not a recognized value"):format(assist), {
      "Set NVIM_AI_ASSIST to off or codecompanion",
    })
    return
  end

  if not env("NVIM_AI_ASSIST") then
    health.warn("assist enabled via legacy CONFIG_USE_CODECOMPANION/CONFIG_USE_AVANTE", {
      "Replace it with NVIM_AI_ASSIST=codecompanion in ~/.local.sh",
    })
  end

  local cc = plugin_state("codecompanion.nvim")
  if cc and not cc.installed then
    health.warn("codecompanion.nvim is not installed yet", { "Run :Lazy install" })
  elseif cc and cc.in_spec then
    health.ok("codecompanion.nvim " .. (cc.loaded and "loaded" or "installed"))
  end

  -- Mirrors the adapter fallback chains in plugins/ai.lua.
  local chat = env("OLLAMA_API_BASE_URL") and "ollama"
    or env("OPENAI_API_KEY") and "openai"
    or env("ANTHROPIC_API_KEY") and "anthropic"
    or "copilot"
  local inline = env("OPENAI_API_KEY") and "openai" or env("ANTHROPIC_API_KEY") and "anthropic" or "copilot"
  health.info(
    ("adapters: chat=%s, inline=%s (priority: OLLAMA_API_BASE_URL > OPENAI_API_KEY > ANTHROPIC_API_KEY > copilot)"):format(
      chat,
      inline
    )
  )
end

local function check_env()
  health.start("Environment (set in ~/.local.sh, see local.sh.example)")

  for _, name in ipairs({
    "NVIM_AI_COMPLETION",
    "NVIM_AI_NES",
    "NVIM_AI_ASSIST",
    "NVIM_AI_LLAMA_PORT",
    "NVIM_AI_FIREWORKS_MODEL",
    "FIREWORKS_API_KEY",
    "ANTHROPIC_API_KEY",
    "OPENAI_API_KEY",
    "OLLAMA_API_BASE_URL",
  }) do
    health.info(("%s: %s"):format(name, env(name) and "set" or "unset"))
  end

  for _, name in ipairs({ "CONFIG_USE_CODECOMPANION", "CONFIG_USE_AVANTE" }) do
    if env(name) then
      health.warn(name .. " is set (legacy)", { "Replace it with NVIM_AI_ASSIST=codecompanion" })
    end
  end
end

function M.check()
  local ok, ai = pcall(require, "config.ai")
  if not ok then
    health.error("could not require('config.ai'): " .. tostring(ai))
    return
  end

  check_completion(ai)
  check_nes(ai)
  check_assist(ai)
  check_env()
end

return M
