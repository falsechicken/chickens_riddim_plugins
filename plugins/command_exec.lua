--[[
Command_Exec
!WARNING WARNING : DANGEROUS DANGEROUS!
Allows users to run arbitrary Lua code. You obviously do not want users running random code on your machine. Use with caution.
Licensed Under the GPLv2
--]]

local perms = require("riddim/ai_utils/permissions");
local jid_tool = require("riddim/ai_utils/jid_tool");

local BOT;

local CheckPermissions = function(_command)
	if _command.stanza.attr.type == "groupchat" then
		if perms.HasPermission(_command.sender["jid"], "command_exec", BOT.config.permissions) == false then
			return false;
		end
		return true;
	else
		if perms.HasPermission(jid_tool.StripResourceFromJID(_command.sender["jid"]), "command_exec", BOT.config.permissions) == false then
			return false;
		end
		return true;
	end
end

function riddim.plugins.command_exec(_bot)
	_bot:hook("commands/exec", ParseExecCommand);
	BOT = _bot;
end

function ParseExecCommand(_command)

	if CheckPermissions(_command) then
		if _command.param == nil then _command:reply("Missing argument. Usage: @exec <Statement or Function>"); return; end
		local f = loadstring(_command.param);
		local r, e = pcall(f);
		if r then _command:reply(tostring(e));
		else _command:reply("Error: "..tostring(e)); end
		return;
	else
		_command:reply("You are not authorized to run this command.");
		return;
	end

end
