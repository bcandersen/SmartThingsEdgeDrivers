-- Copyright 2021 SmartThings
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local capabilities = require "st.capabilities"
--- @type st.zwave.defaults
local defaults = require "st.zwave.defaults"
--- @type st.zwave.Driver
local ZwaveDriver = require "st.zwave.driver"
local configsMap = require "configurations"

local function added_handler(self, device)
  local configs = configsMap.get_device_parameters(device)
  if configs then
    device:emit_event(capabilities.button.numberOfButtons({value = configs.number_of_buttons}))
    device:emit_event(capabilities.button.supportedButtonValues(configs.supported_button_values))
  else
    device:emit_event(capabilities.button.numberOfButtons({ value=1 }))
    device:emit_event(capabilities.button.supportedButtonValues({"pushed", "held"}))
  end
end

local driver_template = {
  supported_capabilities = {
    capabilities.button,
    capabilities.battery
  },
  lifecycle_handlers = {
    added = added_handler,
  },
  sub_drivers = {
    require("zwave-multi-button")
  }
}

defaults.register_for_default_handlers(driver_template, driver_template.supported_capabilities)
--- @type st.zwave.Driver
local button = ZwaveDriver("zwave_button", driver_template)
button:run()
