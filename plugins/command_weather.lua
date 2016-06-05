--[[
Licensed Under the GPLv2
--]]

local datamanager = require("util.datamanager");
local jidTool = require("riddim/ai_utils/jid_tool");
local stanzaUtils = require("riddim/ai_utils/stanzautils");
local tableUtils = require("riddim/ai_utils/tableutils");

local BOT;

local groupChatMessage = "This command cannot be used in group chat.";

local zipMissingMessage = "I don't know your zip code! Set it with: @weatherset <Zip Code> (U.S. only)."

function riddim.plugins.command_weather(_bot)
	_bot:hook("commands/weather", ParseWeatherCommand);
	_bot:hook("commands/forecast", ParseForecastCommand);
	_bot:hook("commands/weatherset", ParseWeatherSetCommand);
	BOT = _bot;
end

function ParseWeatherCommand(_command)

	if stanzaUtils.IsGroupChat(_command) then return groupChatMessage; end
	
	local jid, host, resource = jidTool.SeperateFullJID(_command.sender["jid"]);
	
	local zipStorage = datamanager.load(jid, host, "weatherZip");
	
	if zipStorage == nil then return zipMissingMessage; end
	
	local handle = io.popen("weather-util "..zipStorage[1]);
	local result = "\n"..handle:read("*a");
	handle:close();
	
	return result;

end

function ParseForecastCommand(_command)

	if stanzaUtils.IsGroupChat(_command) then return groupChatMessage; end
	
	local jid, host, resource = jidTool.SeperateFullJID(_command.sender["jid"]);
	
	local zipStorage = datamanager.load(jid, host, "weatherZip");
	
	if zipStorage == nil then return zipMissingMessage; end
	
	local handle = io.popen("weather-util -f "..zipStorage[1]);
	local result = "\n"..handle:read("*a");
	handle:close();
	
	return result;
	
end

function ParseWeatherSetCommand(_command)

	if stanzaUtils.IsGroupChat(_command) then return groupChatMessage; end
  
	if _command.param == nil then return "Missing zip code!"; end
	
	local jid, host, resource = jidTool.SeperateFullJID(_command.sender["jid"]);
	
	local zipStorage = {};
	
	zipStorage[1] = _command.param;
		
	datamanager.store(jid, host, "weatherZip", zipStorage);
			
	return "Saved weather zip.";

end
