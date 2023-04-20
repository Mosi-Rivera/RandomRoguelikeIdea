local bindings;
local methods = {};
local keypressed = {};
local keyreleased = {};

function methods.init(_bindings)
	bindings = _bindings;
end

function methods.update()
	keypressed = {};
	keyreleased = {};
end

function methods.onpressevent(k)
	keypressed[k] = true;
end

function methods.onreleaseevent(k)
	keyreleased[k] = true;
end

function methods.isDown(action)
	return (love.keyboard.isDown(bindings[action]));
end

function methods.wasPressed(action)
	return (keypressed[bindings[action]]);
end


function methods.wasReleased(action)
	return (keyreleased[bindings[action]]);
end

return (methods);