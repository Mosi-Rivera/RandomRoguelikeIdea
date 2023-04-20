local grid = require('combat.grid_system.grid');
local cell = require('combat.grid_system.cell');
local character = require('combat.characters.character');
local interface = {};
local move_buffer;
local move_direction;
local C_BUFFER_TIME = 0.2;
local moving = false;
local moving_timer;
local current_move_direction;
local C_MOVE_TIME = 0.6;

function interface.init()
    move_buffer = 0;
    move_direction = 1;
end

local function canMove(character)
    return (
        not character.stunned and
        not character.rooted and
        not character.cast_lock
    )
end

local function setMovePosition()
    local _character = COMBAT_SYSTEM.getCharacter();
    local tx, ty = cell.getDimensions();
    local abs_direction = math.abs(current_move_direction);
    local sign_direction = -(current_move_direction > 0 and 1 or -1);
    if abs_direction == 1 then
        character.setMoveOffsetX(_character, math.floor((moving_timer / C_MOVE_TIME) * tx * sign_direction));
    else
        character.setMoveOffsetY(_character, ((moving_timer / C_MOVE_TIME) * ty * sign_direction));
    end
end

local function resetMovePosition()
    local _character = COMBAT_SYSTEM.getCharacter();
    character.setMoveOffsetX(_character, 0);
    character.setMoveOffsetY(_character, 0);
end

local function move()
    local _character = COMBAT_SYSTEM.getCharacter();
    local current_cell = _character.tile;
    local target_index = current_cell.index + move_direction;
    local target = grid.getCell(
        (target_index - 1) % 6 + 1,
        math.floor((target_index - 1) / 6) + 1
    );
    if not target or not cell.canMoveToCell(target, current_cell) then return end
    cell.removeOccupying(current_cell);
    cell.addOccupying(target, _character);
    move_buffer = 0;
    moving_timer = C_MOVE_TIME;
    moving = true;
    current_move_direction = move_direction;
    character.setMoving(_character, true);
    setMovePosition();
end

function interface.update(dt)
    move_buffer = move_buffer - dt;
    if KEYBOARD_MANAGER.wasPressed('left') then
        move_direction = -1;
        move_buffer = C_BUFFER_TIME;
    elseif KEYBOARD_MANAGER.wasPressed('right') then
        move_direction = 1;
        move_buffer = C_BUFFER_TIME;
    elseif KEYBOARD_MANAGER.wasPressed('down') then
        move_direction = 6;
        move_buffer = C_BUFFER_TIME;
    elseif KEYBOARD_MANAGER.wasPressed('up') then
        move_direction = -6;
        move_buffer = C_BUFFER_TIME;
    end
    if not moving then
        if move_buffer > 0 and canMove(COMBAT_SYSTEM.getCharacter()) then
            move();
        end
    else
        moving_timer = moving_timer - dt;
        if moving_timer <= 0 then
            moving = false;
            moving_timer = 0;
            character.setMoving(COMBAT_SYSTEM.getCharacter(), false);
            resetMovePosition();
        else
            setMovePosition();
        end
    end
end

function interface.dispose()
    move_buffer = nil;
    move_direction = nil;
end

return (interface);