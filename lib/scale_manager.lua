local screen = require('config.screen');
local scale_manager = {};
local world_width;
local world_height;
local scale_x;
local scale_y;
local offset_x;
local offset_y;
local fullscreen;
local resizable;
local width;
local height;

function scale_manager.init()
    width = screen.width;
    height = screen.height;
    fullscreen = screen.fullscreen;
    resizable = screen.resizable;
    scale_manager.updateMode(fullscreen, resizable);
    scale_manager.resize(width, height);
end

function scale_manager.updateMode(_fullscreen, _resizable)
    fullscreen = _fullscreen;
    resizable = _resizable;
    love.window.updateMode(
        width,
        height,
        {
            fullscreen = fullscreen,
            resizable = resizable
        }
    );
end

function scale_manager.resize(w, h)
    world_width = screen.virtual_width;
    world_height = screen.virtual_height;
    width = screen.width;
    height = screen.height;
    scale_x, scale_y = w / world_width, h / world_height;
    local scale = math.min(scale_x, scale_y);
    offset_x = math.floor((scale_x - scale) * world_width / 2);
    offset_y = math.floor((scale_y - scale) * world_height / 2);
    scale_x, scale_y = scale, scale;
end

function scale_manager.worldToScreenX(x)
    return (x * scale_x);
end

function scale_manager.worldToScreenY(y)
    return (y * scale_y);
end

function scale_manager.worldToScreen(x, y)
    return scale_manager.worldToScreenX(x), scale_manager.worldToScreenY(y);
end

function scale_manager.screenToWorldX(x)
    return (x - offset_x) / scale_x;
end

function scale_manager.screenToWorldY(y)
    return (y - offset_y) / scale_y;
end

function scale_manager.screenToWorld(x, y)
    return scale_manager.screenToWorldX(x), scale_manager.screenToWorldY(y);
end

function scale_manager.drawStartPrep()
    love.graphics.translate(offset_x, offset_y);
    love.graphics.setScissor(
        offset_x,
        offset_y,
        world_width * scale_x,
        world_height * scale_y
    );
end
function scale_manager.start()
    love.graphics.push();
    love.graphics.scale(scale_x, scale_y);
end

function scale_manager.finish()
    love.graphics.pop();
end

function scale_manager.drawFinishPrep()
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5, 1);
    love.graphics.setScissor();
end

function scale_manager.print(text, x, y, w, align, color)
    love.graphics.setColor(color);
    love.graphics.printf(
        text,
        math.floor(scale_manager.worldToScreenX(x)),
        math.floor(scale_manager.worldToScreenY(y)),
        math.floor(scale_manager.worldToScreenX(w)),
        align
    );
end

function scale_manager.drawQuad(sprite, quad, x, y)
    love.graphics.draw(
        sprite,
        quad,
        x,
        y
    );
end

return (scale_manager);