local interface = {};

function interface.new(sprite, quads, frames, fps, config)
    config = config or {};
    return ({
        index = 1,
        frames = frames,
        yoyo = config.yoyo,
        _repeat = config._repeat,
        fps = 1 / fps,
        sprite = sprite,
        quads = quads,
        dir = 1,
        timer = 0,
        ox = (config.ox and config.width) and math.floor(config.width * config.ox) or 0,
        oy = (config.oy and config.height) and math.floor(config.height * config.oy) or 0
    });
end

function interface.resetAnimation(anim)
    anim.index = 1;
    anim.dir = 1;
    anim.timer = 0;
end

function interface.newGroup(_default)
    return (
        {
            anims = {},
            active = _default
        }
    );
end

function interface.setGroupActive(group, key)
    group.active = key;
end

function interface.addAnimToGroup(key, anim, group)
    group.anims[key] = anim;
end

local function yoyoUpdate(anim, dt)
    anim.timer = anim.timer + dt;
    if anim.timer >= anim.fps then
        anim.timer = 0;
        anim.index = anim.index + anim.dir;
        if anim.index >= #anim.frames then
            anim.index = #anim.frames;
            anim.dir = -anim.dir;
        elseif anim.index <= 1 then
            anim.index = 1;
            anim.dir = -anim.dir;
        end
    end
end

local function update(anim, dt)
    anim.timer = anim.timer + dt;
    if anim.timer >= anim.fps then
        anim.timer = 0;
        anim.index = anim.index + anim.dir;
        if anim.index > #anim.frames then
            anim.index = 1;
        end
    end
end

function interface.update(anim, dt)
    if anim.yoyo then
        yoyoUpdate(anim, dt);
    else
        update(anim, dt);
    end
end

function interface.draw(anim, x, y)
    local quad = SPRITE_MANAGER.getQuads(anim.quads)[anim.frames[anim.index]];
    SCALE_MANAGER.drawQuad(
        SPRITE_MANAGER.getSprite(anim.sprite),
        quad,
        x - anim.ox,
        y - anim.oy
    );
end

function interface.updateGroup(group, dt)
    interface.update(group.anims[group.active], dt);
end

function interface.drawGroup(group, x, y)
    interface.draw(group.anims[group.active], x, y);
end

return (interface);