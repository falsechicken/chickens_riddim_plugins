--[[
Reboot
Used with a external script in a loop that will restart the bot after exiting. If this script does not exist the bot will simply exit.
--]]

local timer = require("util.timer");
local logMan = require("riddim/ai_utils/logman");
local jidTool = require("riddim/ai_utils/jid_tool");
local tableUtils = require("riddim/ai_utils/tableutils");
local perms = require("riddim/ai_utils/permissions");

local rebootQueued = false;
local BOT = nil;

local CheckPermissions = function(_command)
  if _command.stanza.attr.type == "groupchat" then -- We need to check slightly differently if we are in group chat currently.
    if perms.HasPermission(_command.sender["jid"], "reboot", BOT.config.permissions) then -- User has permission.;
      return true;
    end
    return false;
  else
    if perms.HasPermission(jidTool.StripResourceFromJID(_command.sender["jid"]), "reboot", BOT.config.permissions) then -- User has permission.
      return true;
    end
    return false;
  end
end

function riddim.plugins.command_reboot(_bot)
	_bot:hook("commands/reboot", Reboot);
	timer.add_task(2, CheckRebootQueue);
	BOT = _bot;
end

function Reboot(_command)
  
  if CheckPermissions(_command) == true then
    logMan.LogMessage("Reboot command called by ".._command.sender["jid"], 1);
    _command:reply("Catch ya on the flip side!");
    rebootQueued = true;
    return true;
  end
  
  logMan.LogMessage("Unauthorized user ".._command.sender["jid"].." attempted reboot!", 2);
  _command:reply("You are not authorized to run this command.");
  return false;

end

function CheckRebootQueue() -- Work around using a timer and bool. Reply message will not send if the VM exits before the method returns.
	if rebootQueued == true then
		os.exit();
	end
	return 2;
end

