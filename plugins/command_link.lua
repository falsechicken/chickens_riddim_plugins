--[[
Command_Link
Allows links (Or any text) to be displayed with a command.
Licensed Under the GPLv2
--]]

local tableUtils = require("riddim/ai_utils/tableutils");

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

function riddim.plugins.command_link(_bot)
	_bot:hook("commands/link", ProcessLinkCommand);
  BOT = _bot;
end

function ProcessLinkCommand(_command)

  if BOT.config.links == nil then _command:reply(tableUtils.GetRandomEntry(failResponses)); return false; end
			
    for title, link in pairs(BOT.config.links) do
			if _command.param == title then
				_command:reply(tableUtils.GetRandomEntry(successResponses)..": "..link);
				return true;
			end
		end
	
	_command:reply(tableUtils.GetRandomEntry(failResponses));
	return false;
end
