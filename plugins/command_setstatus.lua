--[[
Command_SetStatus
Allows users to set bot status via command.
Licensed Under the GPLv2
--]]

local permissions = require("riddim/ai_utils/permissions");
local jid_tool = require("riddim/ai_utils/jid_tool");

local BOT;

local CheckPermissions = function(_command)
	if _command.stanza.attr.type == "groupchat" then
		if permissions.HasPermission(_command.sender["jid"], "setstatus", BOT.config.permissions) == false then
			return false;
		end
		return true;
	else
		if permissions.HasPermission(jid_tool.StripResourceFromJID(_command.sender["jid"]), "setstatus", BOT.config.permissions) == false then
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
		BOT.stream:set_status({ msg = _command.param });
	else
		_command:reply("You are not authorized to set status.");
	end
	
end
