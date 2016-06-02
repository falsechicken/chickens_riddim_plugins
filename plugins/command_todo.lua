--[[
Command_Todo
Allows users to store and show a todo list.
--]]

local datamanager = require "util.datamanager";
local timer = require "util.timer";
local jidTool = require "riddim/ai_utils/jid_tool";

function riddim.plugins.command_todo(bot)
	bot:hook("commands/todoadd", ParseAddCommand);
	bot:hook("commands/todoshow", ParseShowCommand);
	bot:hook("commands/todorm", ParseRemoveCommand);
  bot:hook("commands/todo", ParseHelpCommand);
end

-- Command Parsers

function ParseAddCommand(command)

	if command.stanza.attr.type == 'groupchat' then return; end
	
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
			
	return "Got it.";

end

function ParseShowCommand(command)

	if command.stanza.attr.type == 'groupchat' then return; end
	
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

	if command.stanza.attr.type == 'groupchat' then return; end
	
	if command.param == nil then return "Missing todo number. @todo for help."; end
	
	local jid, host, resource = jidTool.SeperateFullJID(command.sender["jid"]);
	
	local todoStorage = datamanager.load(jid, host, "todos");
		
	if todoStorage == nil then return "No todos set."; end
	
	table.remove(todoStorage, command.param);
	
	datamanager.store(jid, host, "todos", todoStorage);
	
	return "Todo "..command.param.." removed.";
	
end

function ParseHelpCommand(command)

  if command.stanza.attr.type == 'groupchat' then return; end
  
  local reply = "\n"..[[- Todo Command Help -
   - @todo - Show help message.
   - @todoadd <Todo> - Add todo.
   - @todorm <number> - Remove todo.
   - @todoshow - Show todos.]]
  
  command:reply(reply);

end

-- End Command Parsers