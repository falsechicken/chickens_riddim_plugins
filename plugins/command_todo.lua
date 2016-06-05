--[[
Command_Todo
Allows users to store and show a todo list.
--]]

local datamanager = require("util.datamanager");
local timer = require("util.timer");
local jidTool = require("riddim/ai_utils/jid_tool");
local stanzaUtils = require("riddim/ai_utils/stanzautils");
local tableUtils = require("riddim/ai_utils/tableutils");

local BOT;

local helpMessage = "\n"..[[- Todo Command Help -
   - @todo - Show help message.
   - @todoadd <Todo> - Add todo.
   - @todorm <number> - Remove todo.
   - @todoshow - Show todos.]];
   
local groupChatMessage = "This command cannot be used in group chat.";

function riddim.plugins.command_todo(_bot)
	_bot:hook("commands/todoadd", ParseAddCommand);
	_bot:hook("commands/todoshow", ParseShowCommand);
	_bot:hook("commands/todorm", ParseRemoveCommand);
	_bot:hook("commands/todo", ParseHelpCommand);
	BOT = _bot;
end

-- Command Parsers

function ParseAddCommand(command)
  
  if stanzaUtils.IsGroupChat(command) then return groupChatMessage; end
  
	if command.param == nil then return "Missing todo. @todo for help."; end
	
	local jid, host, resource = jidTool.SeperateFullJID(command.sender["jid"]);
	
	local todoStorage = datamanager.load(jid, host, "todos")
		
	if todoStorage == nil then
		todoStorage = { command.param };
		datamanager.store(jid, host, "todos", todoStorage);
	else
		table.insert(todoStorage, command.param);
		datamanager.store(jid, host, "todos", todoStorage);
	end
			
	return "Todo added.";

end

function ParseShowCommand(command)

  if stanzaUtils.IsGroupChat(command) then return groupChatMessage; end
	
	local jid, host, resource = jidTool.SeperateFullJID(command.sender["jid"]);
	
	local todoStorage = datamanager.load(jid, host, "todos");
	
	if todoStorage == nil then return "Todo list empty. @todo for help."; end
	
	local response = "\nTodo List:\n";
	
	for i,line in ipairs(todoStorage) do
      response = response.."["..i.."] "..line.."\n";
  end
	
	return response;
end

function ParseRemoveCommand(command)
    
  if stanzaUtils.IsGroupChat(command) then return groupChatMessage; end
	
	if command.param == nil then return "Missing todo number. @todo for help."; end
	
	local jid, host, resource = jidTool.SeperateFullJID(command.sender["jid"]);
	
	local todoStorage = datamanager.load(jid, host, "todos");
  
  if tableUtils.DoesTableContainKey(command.param, todoStorage) == false then return "Todo does not exist."; end
  
  if todoStorage == nil then return "No todos set."; end
	
  table.remove(todoStorage, command.param);
	
	datamanager.store(jid, host, "todos", todoStorage);
	
	return "Todo "..command.param.." removed.";
	
end

function ParseHelpCommand(command)
  
  if stanzaUtils.IsGroupChat(command) then return groupChatMessage; end -- Ignore message from MUC rooms.
    
  return helpMessage;

end

-- End Command Parsers
