local stack_state_manager = {};

function stack_state_manager.new(states, default)
    return ({
        stack = {},
        states = states
    });
end

function stack_state_manager.onexit(sm)
    sm.active.onexit();
end


function stack_state_manager.onenter(sm)
    sm.active.onenter();
end

function stack_state_manager.setState(sm, key)
    stack_state_manager.onexit(sm);
    table.insert(sm.stack, sm.states[key]);
    stack_state_manager.onenter(sm);
end

function stack_state_manager.update(sm, ...)
    if sm.update(...) then
        table.remove(sm.stack);
    end
end


function stack_state_manager.draw(sm, ...)
    sm.draw(...);
end

return (stack_state_manager);