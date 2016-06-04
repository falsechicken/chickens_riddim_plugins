--[[
Default_Status
Reads a status from the config file and sets the bots status.
Licensed Under the GPLv2
--]]

local BOT;

local logMan = require("riddim/ai_utils/logman");

function riddim.plugins.default_status(_bot)
	_bot.stream:add_plugin("presence");
	_bot:hook("started", SetStatus, -1);
	BOT = _bot;
end

function SetStatus()
	if BOT.config.default_status == nil then
		logMan.LogMessage("Plugin default_status: Enabled but no default_status var found in config!", 2);
	else
		BOT.stream:set_status({ msg = BOT.config.default_status });
	end
end
