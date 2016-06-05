--[[
Command_Perms
Allows users to check their permissions. (Requires ai_utils from ai_loader)
Licensed Under the GPLv2
--]]

local permissions = require("riddim/ai_utils/permissions");
local jid_tool = require("riddim/ai_utils/jid_tool");


local BOT;

local CheckPermissions = function(_command)
	if _command.stanza.attr.type == "groupchat" then
		if permissions.HasPermission(_command.sender["jid"], "command_perms", BOT.config.permissions) == false then
			return false;
		end
		return true;
	else
		if permissions.HasPermission(jid_tool.StripResourceFromJID(_command.sender["jid"]), "command_perms", BOT.config.permissions) == false then
			return false;
		end
		return true;
	end
end

function riddim.plugins.command_perms(_bot)
	_bot:hook("commands/perms", ParsePermsCommand);
	BOT = _bot;
end

function ParsePermsCommand(_command)

	if CheckPermissions(_command) then
		local permsList;
		
		local tempPersonalPerms = {};
		local tempDefaultPerms = {};
		
		if _command.stanza.attr.type == "groupchat" then
			tempPersonalPerms = BOT.config.permissions[_command.sender["jid"]];
			permsList = "\n-- Your Permissions In Room --";
		else
			tempPersonalPerms = BOT.config.permissions[jid_tool.StripResourceFromJID(_command.sender["jid"])];
			permsList = "\n-- Your Permissions --";
		end
		
		tempDefaultPerms = BOT.config.permissions["DEFAULT"];
		
		for pk, personalPermission in pairs(tempPersonalPerms) do
			for dk, defaultPermission in pairs(tempDefaultPerms) do
				if personalPermission == defaultPermission then tempPersonalPerms[pk] = nil; end -- Remove default permission from personal list.
			end
		end
		
		for dk, defaultPermission in pairs(tempDefaultPerms) do 
			table.insert(tempPersonalPerms, defaultPermission); -- Add all the default permissions to the personal permission table now that dupes should not exist.
		end
			
		for key, permission in pairs(tempPersonalPerms) do
			permsList = permsList.."\n - "..permission;
		end
		
		permsList = permsList.."\n--------------------------------";
		
		return permsList;
		
	else	
		return "You are not authorized to run this command.";
	end
end
