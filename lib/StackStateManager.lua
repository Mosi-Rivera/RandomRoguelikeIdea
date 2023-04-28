local stack_state_manager = {};

function stack_state_manager.new(states, _default)
    return ({
        stack = {states[_default].new(_default)},
        states = states
    });
end

local function getActive(sm)
    return (sm.stack[#sm.stack]);
end

function stack_state_manager.onexit(sm)
    local active;

    active = getActive(sm);
    sm.states[active.key].onexit(active);
end


function stack_state_manager.onenter(sm)
    local active;

    active = getActive(sm);
    sm.states[active.key].onenter(active);
end

function stack_state_manager.setState(sm, key)
    stack_state_manager.onexit(sm);
    table.insert(sm.stack, sm.states[key].new(key));
    stack_state_manager.onenter(sm);
end

function stack_state_manager.update(sm, ...)
    local active;

    active = getActive(sm);
    if sm.states[active.key].update(active, ...) then
        table.remove(sm.stack);
    end
end

function stack_state_manager.draw(sm, ...)
    local active;

    active = getActive(sm);
    sm.states[active.key].draw(active, ...);
end

return (stack_state_manager);