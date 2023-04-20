local animation = require('lib.animation');
local character = require('combat.characters.character');
local grid = require('combat.grid_system.grid');
local C_ATTACK_TIME = 0.4;

return function(_character, cp)
    local anim = animation.new(
        'attacks',
        'attacks',
        {2},
        8,
        {
            yoyo = true,
            width = 50,
            height = 50,
            ox = 0.5,
            oy = 1
        }
    );
    local tile = _character.tile;
    local x, y = (tile.index - 1) % 6 + 1, math.floor((tile.index - 1) / 6) + 1;
    local dx, dy = grid.getCenteredTilePosition(x, y);
    local direction = tile.is_player and 1 or -1;
    local timer = C_ATTACK_TIME;
    character.setCastLock(_character, true);
    return ({
        update = function(dt)
            animation.update(anim, dt);
            timer = timer - dt;
            if timer <= 0 then
                timer = C_ATTACK_TIME;
                x = x + direction;
                if x > 6 or x < 0 then
                    character.setCastLock(_character, false);
                    return (true);
                end
                dx, dy = grid.getCenteredTilePosition(x, y);
            end
        end,
        draw = function()
            animation.draw(anim, dx, dy);
        end
    });
end