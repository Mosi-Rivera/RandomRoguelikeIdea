local basic_state_manager = {};

function basic_state_manager.new(states, default)
    return ({
        active = states[default],
        states = states
    });
end

function basic_state_manager.onexit(sm)
    sm.active.onexit();
end


function basic_state_manager.onenter(sm)
    sm.active.onenter();
end

function basic_state_manager.setState(sm, key)
    basic_state_manager.onexit(sm);
    sm.active = sm.states[key];
    basic_state_manager.onenter(sm);
end

function basic_state_manager.update(sm, ...)
    local ret = sm.active.update(...);
    if ret ~= nil then
        basic_state_manager.setState(sm, ret);
    end
end


function basic_state_manager.draw(sm, ...)
    sm.active.draw(...);
end

return (basic_state_manager);