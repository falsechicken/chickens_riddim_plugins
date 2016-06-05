--[[
Command_Random
Allows users to generate random things. Like numbers, picking a random user in muc room, etc.
Licensed Under the GPLv2
--]]

local tableUtils = require("riddim/ai_utils/tableutils");
local jid_tool = require("riddim/ai_utils/jid_tool");
local permissions = require("riddim/ai_utils/permissions");


local BOT;

local helpMessage = "\n"..[[
- Generates Random Stuff -
Usage: @random <argument>
- Arguments -
# user - Picks a random user in a muc room.
]];

local invalidArgumentMessage = "Invalid argument. Run @random for help."

local CheckPermissions = function(_command)
	if _command.stanza.attr.type == "groupchat" then
		if permissions.HasPermission(_command.sender["jid"], "command_random", BOT.config.permissions) == false then
			return false;
		end
		return true;
	else
		if permissions.HasPermission(jid_tool.StripResourceFromJID(_command.sender["jid"]), "command_random", BOT.config.permissions) == false then
			return false;
		end
		return true;
	end
end

function riddim.plugins.command_random(_bot)
	_bot:hook("commands/random", ProcessRandomCommand);
	BOT = _bot;
end

function ProcessRandomCommand(_command)
	if CheckPermissions(_command) then

		if _command.param == nil then return helpMessage; end
		if _command.param == "user" then
			return tableUtils.GetRandomKey(_command.room.occupants);
		else
			return invalidArgumentMessage;
		end
		
	else
		return "You are not authorized to run this command.";
	end
end
