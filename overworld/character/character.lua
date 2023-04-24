local interface = {};
local character_data = require('overworld.data.character_data');
local drawable_interface = require('lib.drawable');
local animation = require('lib.animation');

function interface.init(id, sx, sy)
    local data = character_data[id];
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
        remainder_x = 0,
        remainder_y = 0,
        speed_x = 0,
        speed_y = 0
    }, anims, _default);
end

function interface.update(character, dt)
    drawable_interface.update(character, dt);
end

return (interface);