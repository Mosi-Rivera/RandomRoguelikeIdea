local interface = {};
local tilemap_interface = require('overworld.tilemap.tilemap');
local math_helpers = require('lib.math_helpers');
local C_MOVE_SPEED = 64;

local function moveX(character, map, amount)
    local move;
    local sign;
    local x;
    local y;

    character.remainder_x = character.remainder_x + amount;
    move = math.floor(character.remainder_x + 0.5);

    if move ~= 0 then
        character.remainder_x = character.remainder_x - move;
        sign = move < 0 and -1 or 1;
        x = character.x + (sign < 0 and -14 or 13);
        y = character.y;
        while (move ~= 0) do
            if (
                not tilemap_interface.isCollidableTile(map, x + sign, y - 4) and
                not tilemap_interface.isCollidableTile(map, x + sign, y + 11)
            ) then
                character.x = character.x + sign;
                x = x + sign
                move = move - sign;
            else
                break;
            end
        end
    end
end

local function moveY(character, map, amount)
    local move;
    local sign;
    local x;
    local y;

    character.remainder_y = character.remainder_y + amount;
    move = math.floor(character.remainder_y + 0.5);

    if move ~= 0 then
        character.remainder_y = character.remainder_y - move;
        sign = move < 0 and -1 or 1;
        x = character.x;
        y = character.y + (sign < 0 and -4 or 11);
        while move ~= 0 do
            if (
                not tilemap_interface.isCollidableTile(map, x - 14, y + sign) and
                not tilemap_interface.isCollidableTile(map, x + 13, y + sign)
            ) then
                character.y = character.y + sign;
                y = y + sign;
                move = move - sign;
            else
                break;
            end
        end
    end
end

function interface.update(map, character, dt)
    local mx;
    local my;
    local magnitude;

    mx = (KEYBOARD_MANAGER.isDown('right') and 1 or 0) - (KEYBOARD_MANAGER.isDown('left') and 1 or 0);
    my = (KEYBOARD_MANAGER.isDown('down') and 1 or 0) - (KEYBOARD_MANAGER.isDown('up')  and 1 or 0);
    if mx ~= 0 or my ~= 0 then
        magnitude = math.sqrt(mx^2 + my^2);
        mx = mx / magnitude;
        my = my / magnitude;
    end
    character.speed_x = math_helpers.approach(character.speed_x, C_MOVE_SPEED * mx, 800 * dt);
    character.speed_y = math_helpers.approach(character.speed_y, C_MOVE_SPEED * my, 800 * dt);
    moveX(character, map, character.speed_x * dt);
    moveY(character, map, character.speed_y * dt);
end

return (interface);