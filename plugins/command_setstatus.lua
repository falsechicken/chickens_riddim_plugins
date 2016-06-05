--[[
Command_SetStatus
Allows users to set bot status via command.
Licensed Under the GPLv2
--]]

local permissions = require("riddim/ai_utils/permissions");
local jid_tool = require("riddim/ai_utils/jid_tool");

local BOT;

local helpMessge = "Sets the status of the bot. Usage: @setstatus <status> or $DEFAULT to use config default.";

local CheckPermissions = function(_command)
	if _command.stanza.attr.type == "groupchat" then
		if permissions.HasPermission(_command.sender["jid"], "command_setstatus", BOT.config.permissions) == false then
			return false;
		end
		return true;
	else
		if permissions.HasPermission(jid_tool.StripResourceFromJID(_command.sender["jid"]), "command_setstatus", BOT.config.permissions) == false then
			return false;
		end
		return true;
	end
end

function riddim.plugins.command_setstatus(_bot)
	_bot:hook("commands/setstatus", SetStatus);
	_bot.stream:add_plugin("presence");
	
	BOT = _bot;
end

function SetStatus(_command)
	
	if CheckPermissions(_command) then
		if _command.param == nil then return helpMessge; end
		if _command.param == "$DEFAULT" then
			if BOT.config.default_status == nil then _command:reply("No default status in config."); return; end
		
			BOT.stream:set_status({ msg = BOT.config.default_status });
			return;
		end
		
		BOT.stream:set_status({ msg = _command.param });
		return;
	
	else
		_command:reply("You are not authorized to set bot status.");
	end
	
end
