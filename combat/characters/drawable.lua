local animation_interface = require('lib.animation');
local interface = {};

function interface.makeDrawable(drawable, anims, _default)
    drawable.anim_group = animation_interface.newGroup(_default);
    for k, v in pairs(anims) do
        animation_interface.addAnimToGroup(k, v, drawable.anim_group);
    end
    return (drawable);
end

function interface.update(drawable, dt)
    animation_interface.updateGroup(drawable.anim_group, dt);
end

function interface.draw(drawable, x, y)
    animation_interface.drawGroup(
        drawable.anim_group,
        x + (drawable.move_offset_x or 0),
        y + (drawable.move_offset_y or 0)
    );
end



return (interface);