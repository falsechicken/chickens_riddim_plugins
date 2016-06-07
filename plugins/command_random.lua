--[[
Command_Random
Allows users to generate random things. Like numbers, picking a random user in muc room, etc.
Licensed Under the GPLv2
--]]

local tableUtils = require("riddim/ai_utils/tableutils");
local textUtils = require("riddim/ai_utils/textutils");
local jid_tool = require("riddim/ai_utils/jid_tool");
local permissions = require("riddim/ai_utils/permissions");
local stanzaUtils = require("riddim/ai_utils/stanzautils");


local BOT;

local helpMessage = "\n"..[[
- Generates Random Stuff -
Usage: @random <argument>
# Arguments #
- user - Picks a random user in a muc room.
- number <min> <max> - Picks a random number between two numbers (Inclusive).
- roll <sides> - Simulates a dice roll with specified number of sides.
]];

local invalidArgumentMessage = "Invalid argument. Run @random for help.";
local onlyGroupChatMessage = "This argument only works in group chat.";

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

local GenerateRandomNumberFromString= function(_min, _max)

	math.randomseed(os.time());

	local n1 = tonumber(_min);
	local n2 = tonumber(_max);

	if (type(n1) == "number" and type(n2) == "number") then
		if (n1 <= 0 or n2 <= 0 or n1 > 2147483647 or n2 > 2147483647) then 
			return "Number cannot be negitive or too large. Max size is 2,147,483,647."; end
		if n2 < n1 then return "Max number cannot be smaller than the min number."; end
		
		return tostring(math.random(n1, n2));
	else
		return invalidArgumentMessage;
	end

end

function riddim.plugins.command_random(_bot)
	_bot:hook("commands/random", ProcessRandomCommand);
	BOT = _bot;
end

function ProcessRandomCommand(_command)
	if CheckPermissions(_command) then

		local params = textUtils.Split(_command.param);

		if _command.param == nil then return helpMessage; end

		if params[1] == "user" then
			if stanzaUtils.IsGroupChat(_command) == false then return onlyGroupChatMessage; end
			return tableUtils.GetRandomKey(_command.room.occupants);

		elseif params[1] == "number" then
			return GenerateRandomNumberFromString(params[2], params[3]);

		elseif params[1] == "roll" then
			return GenerateRandomNumberFromString(1, params[2]);
		
		else
			return invalidArgumentMessage;
		end
	
	else
		return "You are not authorized to run this command.";
	end
end
