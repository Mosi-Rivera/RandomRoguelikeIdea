local screen = require('config.screen');
local interface = {};
local width = 50;
local height = 35;
local states = {
    default = 1,
    disabled = 2
}

function interface.new(i)
    local is_player = (i - 1) % 6 + 1 <= 3;
    return ({
        index = i,
        occupying = nil,
        state_stack = {1},
        state_timer = 0,
        state = states.default,
        is_player_default = is_player,
        is_player = is_player,
    });
end

function interface.canMoveToCell(cell, from_cell)
    return (from_cell.is_player == cell.is_player and not cell.occupying and cell.state ~= states.disabled); 
end

function interface.removeOccupying(cell)
    cell.occupying.tile = nil;
    cell.occupying = nil;
end

function interface.addOccupying(cell, character)
    if cell.occupying or (character and character.cell ~= nil) then return (nil) end
    character.tile = cell;
    cell.occupying = character;
    return (cell);
end

function interface.draw(cell, x, y)
    SCALE_MANAGER.drawQuad(
        SPRITE_MANAGER.getSprite('tiles'),
        SPRITE_MANAGER.getQuads('tiles')[cell.is_player and 1 or 2],
        x,
        y
    );
end

function interface.setState(cell, state, time)
    table.insert(cell.state_stack, state);
    cell.state_timer = time;
end

function interface.update(cell, dt)
    if #cell.state_stack ~= 1 then
        cell.state_timer = cell.state_timer - dt;
        if cell.state_timer <= 0 then
            cell.state_timer = 0;
            table.remove(cell.state_stack, #cell.state_stack);
        end
    end
end

function interface.getDimensions()
    return width, height;
end

return (interface);