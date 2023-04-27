local interface = {};
local tilemap_interface = require('overworld.tilemap.tilemap');
local math_helpers = require('lib.math_helpers');
local C_MOVE_SPEED = 64;
local C_MOVE_BUFFER_TIME = 0.2;
local C_TIME_TO_MOVE = 0.3;

local function moveStart(map, character, direction)
    print('move start');
    if direction == 4 then
        character.moving_horizontal = false;
        character.move_oy = 0;
        character.reverse_move = true;
    elseif direction == 3 then
        character.moving_horizontal = true;
        character.move_ox = 0;
        character.reverse_move = true;
    elseif direction == 2 then
        character.moving_horizontal = false;
        character.move_oy = -map.tile_height;
        character.y = character.y + 1;
        character.reverse_move = false;
    elseif direction == 1 then
        character.moving_horizontal = true;
        character.move_ox = -map.tile_width;
        character.x = character.x + 1;
        character.reverse_move = false;
    end
    character.moving = true;
    character.move_timer = C_TIME_TO_MOVE;
end

local function handleInput(map, character)
    if KEYBOARD_MANAGER.isDown('up') then
        if character.y - 1 > 0 and not tilemap_interface.coordIsCollidableTile(map, character.x, character.y - 1) then
            character.move_buffer = C_MOVE_BUFFER_TIME;
        end
        character.move_direction = 4;
    elseif KEYBOARD_MANAGER.isDown('down') then
        if character.y + 1 <= map.height and not tilemap_interface.coordIsCollidableTile(map, character.x, character.y + 1) then
            character.move_buffer = C_MOVE_BUFFER_TIME;
        end
        character.move_direction = 2;
    elseif KEYBOARD_MANAGER.isDown('right') then
        if character.x + 1 <= map.width and not tilemap_interface.coordIsCollidableTile(map, character.x + 1, character.y) then
            character.move_buffer = C_MOVE_BUFFER_TIME;
        end
        character.move_direction = 1;
    elseif KEYBOARD_MANAGER.isDown('left') then
        if character.x - 1 > 0 and not tilemap_interface.coordIsCollidableTile(map, character.x - 1, character.y) then
            character.move_buffer = C_MOVE_BUFFER_TIME;
        end
        character.move_direction = 3;
    end
end

local function checkInput(map, character)
    if character.move_buffer > 0 then
        character.move_buffer = 0;
        moveStart(map, character, character.move_direction);
    end
end

function interface.update(map, character, dt)
    local percentage;

    if character.moving then
        character.move_timer = character.move_timer - dt;
        if character.move_timer <= 0 then
            character.moving = false;
            character.move_ox = 0;
            character.move_oy = 0;
            if character.move_direction == 4 then
                character.y = character.y - 1;
            elseif character.move_direction == 3 then
                character.x = character.x - 1;
            end
            handleInput(map, character);
            checkInput(map, character);
        else
            percentage = character.move_timer / C_TIME_TO_MOVE;
            if character.moving_horizontal then
                character.move_ox = -(character.reverse_move and 1 - percentage or percentage) * map.tile_width;
            else
                character.move_oy = -(character.reverse_move and 1 - percentage or percentage) * map.tile_height;
            end
        end
    else
        handleInput(map, character);
        checkInput(map, character);
    end
end

function interface.getWorldPosition(camera, character)
    local x = (character.x - 1) * camera.tile_width + character.move_ox + character.ox;
    local y = (character.y - 1) * camera.tile_height + character.move_oy + character.oy;
    return x, y;
end

return (interface);