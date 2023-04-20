local interface = {};

function interface.newManager()
    return ({
        events = {},
        max_index = 0
    });
end

local function initAndReturnActive(index, stack, _character, cp)
    return (stack[index](_character, cp));
end

function interface.newStack(stack, _character, data_stack)
    local index = 1;
    local active = stack[index](_character, data_stack[index].cp);
    return {
        update = function(dt)
            if active.update(dt) then
                index = index + 1;
                if index > #stack then
                    return (true);
                end
                active = initAndReturnActive(index, stack, _character, data_stack[index].cp);
            end
        end,
        draw = function()
            active.draw();
        end
    }
end

function interface.addEvent(events, event)
    table.insert(events.events, event);
end

function interface.removeEvent(events, event)
    for i = 1, #events do
        if events[i] == event then
            table.remove(events, i);
            return (true);
        end
    end
    return (false);
end

function interface.update(events, dt)
    local events_tbl = events.events;
    for i = #events_tbl, 1, -1 do
        if events_tbl[i].update(dt) then
            table.remove(events_tbl, i);
        end
    end
end


function interface.draw(events)
    local events_tbl = events.events;
    for i = #events_tbl, 1, -1 do
        events_tbl[i].draw();
    end
end

return (interface);