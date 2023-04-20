local interface = {};
local drawable = require('combat.characters.drawable');
local animation = require('lib.animation');

function interface.new(data)
    local anim_data;
    local anims = {};
    for i = 1, #data.anims do
        anim_data = data.anims[i];
        anims[anim_data.name] = animation.new(
            anim_data.sprite,
            anim_data.quads,
            anim_data.frames,
            anim_data.fps,
            anim_data.config
        );
    end
    return (drawable.makeDrawable(
        {
            cast_lock   = false,
            stunned     = false,
            rooted      = false,
            silenced    = false,
            moving      = false,
            hp          = data.hp,
            name        = data.name,
            cast_speed  = data.cast_speed,
            move_speed  = data.move_speed,
            power       = data.power,
            resistance  = data.resistance,
            tile        = nil,
            move_offset_x = 0,
            move_offset_y = 0
        },
        anims,
        'idle'
    ));
end

function interface.setMoving(character, b)
    character.moving = b;
end

function interface.setMoveOffsetX(character, x)
    character.move_offset_x = x;
end

function interface.setMoveOffsetY(character, y)
    character.move_offset_y = y;
end

function interface.setCastLock(character, b)
    character.cast_lock = b;
    if b then
        animation.setGroupActive(character.anim_group, 'cast');
    else
        animation.setGroupActive(character.anim_group, 'idle');
    end
end

function interface.update(character, dt)
    drawable.update(character, dt);
end

return (interface);