-- Per-machine AI feature tiers, resolved once at startup.
--
-- Completion (inline ghost text), NES (next-edit suggestions), and assist
-- (chat / inline edits) are opted into independently on each machine via
-- environment variables, typically set in ~/.local.sh:
--
--   NVIM_AI_COMPLETION = off | copilot | fireworks | local | auto  (default: auto)
--   NVIM_AI_NES        = off | on                                  (default: on)
--   NVIM_AI_ASSIST     = off | codecompanion                       (default: off)
--
-- "auto" resolves to:
--   local      when a llama-server is listening on 127.0.0.1:$NVIM_AI_LLAMA_PORT
--              (default 8012) — run one as a user service on machines with a
--              capable GPU, e.g.:
--                llama-server -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF --port 8012 -ngl 99
--   fireworks  when FIREWORKS_API_KEY is set
--   copilot    otherwise
--
-- Legacy CONFIG_USE_CODECOMPANION/CONFIG_USE_AVANTE=true map to
-- NVIM_AI_ASSIST=codecompanion (avante has been removed).

local M = {}

M.llama_port = tonumber(os.getenv("NVIM_AI_LLAMA_PORT") or "") or 8012

function M.llama_endpoint()
  return ("http://127.0.0.1:%d/v1/completions"):format(M.llama_port)
end

-- Cheap synchronous probe: localhost connections succeed or are refused in
-- ~1ms; the vim.wait bound only matters if the port is firewalled to DROP.
local function llama_server_up()
  local uv = vim.uv or vim.loop
  local tcp = uv.new_tcp()
  if not tcp then
    return false
  end
  local done, up = false, false
  tcp:connect("127.0.0.1", M.llama_port, function(err)
    up = err == nil
    done = true
    if not tcp:is_closing() then
      tcp:close()
    end
  end)
  vim.wait(200, function()
    return done
  end, 5)
  if not done and not tcp:is_closing() then
    tcp:close()
  end
  return up
end

local completion_tier

local valid_tiers = { off = true, copilot = true, fireworks = true, ["local"] = true }

local function warn(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN)
  end)
end

---@return "off"|"copilot"|"fireworks"|"local"
function M.completion()
  if completion_tier == nil then
    local tier = os.getenv("NVIM_AI_COMPLETION") or "auto"
    if tier == "auto" then
      if llama_server_up() then
        tier = "local"
      elseif os.getenv("FIREWORKS_API_KEY") then
        tier = "fireworks"
      else
        tier = "copilot"
      end
    elseif not valid_tiers[tier] then
      warn(
        ("NVIM_AI_COMPLETION=%s is not a recognized tier (off|copilot|fireworks|local|auto); AI completion disabled"):format(
          tier
        )
      )
      tier = "off"
    elseif tier == "fireworks" and not os.getenv("FIREWORKS_API_KEY") then
      warn("NVIM_AI_COMPLETION=fireworks but FIREWORKS_API_KEY is unset; falling back to copilot")
      tier = "copilot"
    end
    completion_tier = tier
  end
  return completion_tier
end

---@return boolean
function M.nes()
  return (os.getenv("NVIM_AI_NES") or "on") ~= "off"
end

---@return "off"|"codecompanion"
function M.assist()
  local tier = os.getenv("NVIM_AI_ASSIST")
  if tier == nil or tier == "" then
    local legacy = os.getenv("CONFIG_USE_CODECOMPANION") == "true" or os.getenv("CONFIG_USE_AVANTE") == "true"
    tier = legacy and "codecompanion" or "off"
  end
  return tier
end

return M
