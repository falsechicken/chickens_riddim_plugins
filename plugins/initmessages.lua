-- Licensed Under the GPLv2

local logMan = require("riddim/ai_utils/logman");

function riddim.plugins.initmessages(bot)
	logMan.LogMessage("## "..bot.config.nick.." Initializing ##", 1);
	
	print("");
	logMan.LogMessage("## Riddim Plug-ins Enabled ##", 1);
	for k, rP in pairs(bot.config.plugins) do
		logMan.LogMessage("- "..rP, 1);
	end
	logMan.LogMessage("#############################", 1);
	
	print("");
	logMan.LogMessage("## Verse/Stream Plug-ins Enabled ##", 1);
	for k, sP in pairs(bot.config.stream_plugins) do
		logMan.LogMessage("- "..sP, 1);
	end
	logMan.LogMessage("###################################", 1);
	
end


