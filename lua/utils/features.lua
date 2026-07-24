-- Feature flags controlled from the Nix flake (see `astronvim.features` in flake.nix)
-- Each feature is exposed as an `NVIM_FEATURE_<NAME>` env var by the Home Manager module.
-- Missing/unset env vars default to enabled so this works outside of the Nix-managed install too.
local M = {}

function M.enabled(name)
  local value = vim.env["NVIM_FEATURE_" .. name:upper()]
  if value == nil then return true end
  return value == "1"
end

return M
