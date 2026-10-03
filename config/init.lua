local wezterm = require("wezterm") ---@type Wezterm

---@class ConfigBuilder
---@field options Config
local Config = {}
Config._index = Config

---Initialize Config
---@return ConfigBuilder
function Config:init()
  local config = setmetatable({ options = {} }, self)
  return config
end

---Apend to `Config.options`
---@param new_options table new options to Apend
---@return ConfigBuilder
function Config:append(new_options)
  for k, v in pairs(new_options) do
    if self.options[k] ~= nil then
      wezterm.log_warn(
        "Duplicate config option detected: ",
        { old = self.options[k], new = new_options[k] }
      )
      goto continue
    end
    self.options[k] = v
    ::continue::
  end
  return self
end

return Config
