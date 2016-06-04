--[[
Auto_Conf_Reload
Checks the bot config file for changes and reboots the bot when a change is made.
Depends on the md5sum program.
Licensed Under the GPLv2
--]]

local timer = require("util.timer");

local logMan = require("riddim/ai_utils/logman");

local BOT;

local initialMD5;

function riddim.plugins.auto_conf_reload(_bot)
  
  timer.add_task(5, CheckConfigHash);
  BOT = _bot;
  
  local handle = io.popen("md5sum -t config.lua");
  initialMD5 = handle:read("*a");
  handle:close();
  
end

function CheckConfigHash(_event)
  
  local handle = io.popen("md5sum -t config.lua");
  local currentMD5 = handle:read("*a");
  handle:close();
  
  if currentMD5 ~= initialMD5 then RebootBot(); end
  
  return 5;
end

function RebootBot()
  logMan.LogMessage("Config change detected. Restarting "..BOT.config.nick..".", 1);
  os.exit();
end
