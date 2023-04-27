local interface = {};
local character_data = require('overworld.data.character_data');
local drawable_interface = require('lib.drawable');
local animation = require('lib.animation');

function interface.new(data, sx, sy)
    local _default;
    local anim_data;
    local anims = {};
    for i = 1, #data.overworld_anims do
        anim_data = data.overworld_anims[i];
        if anim_data.default then
            _default = anim_data.name;
        end
        anims[anim_data.name] = animation.new(
            anim_data.sprite,
            anim_data.quads,
            anim_data.frames,
            anim_data.fps,
            anim_data.config
        );
    end
    return drawable_interface.makeDrawable({
        x = sx,
        y = sy,
        move_buffer = 0,
        move_direction = 0,
        reverse_move = false,
        moving_horizontal = false,
        move_ox = 0,
        move_oy = 0,
        moving = false,
        move_timer = 0
    }, anims, _default);
end

function interface.update(character, dt)
    drawable_interface.update(character, dt);
end

return (interface);