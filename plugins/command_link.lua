--[[
Command_Link
Allows links (Or any text) to be displayed with a command.
Licensed Under the GPLv2
--]]

local tableUtils = require("riddim/ai_utils/tableutils");
local perms = require("riddim/ai_utils/permissions");
local jidTool = require("riddim/ai_utils/jid_tool");

local BOT;

local successResponses = {
	"Got It",
	"Here ya go",
	"Right here bro",
	"Here it is",
	"Here to serve"
};

local failResponses = {
	"I do not know what link you want?... Sorry.",
	"Uhm... I am unaware of that link... My bad.",
	"Am I supposed to know where that is?",
	"This is the first I am hearing of this..."
};

local CheckPermissions = function(_command, _permission)
  if _command.stanza.attr.type == "groupchat" then -- We need to check slightly differently if we are in group chat currently.
    if perms.HasPermission(_command.sender["jid"], _permission, BOT.config.permissions) then -- User has permission.;
      return true;
    end
    return false;
  else
    if perms.HasPermission(jidTool.StripResourceFromJID(_command.sender["jid"]), _permission, BOT.config.permissions) then -- User has permission.
      return true;
    end
    return false;
  end
end

function riddim.plugins.command_link(_bot)
	_bot:hook("commands/link", ProcessLinkCommand);
	_bot:hook("commands/linklist", ProcessLinkListCommand);
  BOT = _bot;
end

function ProcessLinkCommand(_command)
	if CheckPermissions(_command, "command_link") then
		if BOT.config.links == nil then _command:reply(tableUtils.GetRandomEntry(failResponses)); return false; end
				
			for title, link in pairs(BOT.config.links) do
				if _command.param == title then
					_command:reply(tableUtils.GetRandomEntry(successResponses)..": "..link);
					return true;
				end
			end
		
		_command:reply(tableUtils.GetRandomEntry(failResponses));
		return false;
	else
		_command:reply("You are not authorized to run this command.");
		return;
	end
end

function ProcessLinkListCommand(_command)
	if CheckPermissions(_command, "command_linklist") then
		if BOT.config.links == nil then _command:reply("No link table in config!"); return false; end
		
		local linkList = "\n-- Link List --\n";
		
		for linkTitle, linkAddress in pairs(BOT.config.links) do
			linkList = linkList.."["..linkTitle.."] = [ "..linkAddress.." ]\n";
		end
		
		_command:reply(linkList);
		
		return;
	else
		_command:reply("You are not authorized to run this command.");
		return;
	end
end
