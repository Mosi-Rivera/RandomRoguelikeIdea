local interface = {};


function interface.new(src, param_table)
    local shader = love.graphics.newShader(love.filesystem.read(src));
    for k, v in pairs(param_table) do
        shader:send(k,v);
    end
    return ({
        timer = 0,
        shader = shader,
        interface = interface
    });
end

function interface.update(shader, dt)
    shader.timer = math.max(0, shader.timer - dt);
end

function interface.startDraw(shader)
    love.graphics.setShader(shader.shader);
end

function interface.finishDraw()
    love.graphics.setShader();
end

function interface.reset(shader, time)
    shader.timer = time;
end

return (interface);