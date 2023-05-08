local interface = {};
local timer_name = 'percentage';

function interface.new(src, time, param_table)
    local shader = love.graphics.newShader(love.filesystem.read(src));
    for k, v in pairs(param_table) do
        shader:send(k,v);
    end
    return ({
        timer = 0,
        max_time = time,
        shader = shader,
        interface = interface
    });
end

function interface.update(shader, dt)
    shader.timer = math.min(shader.max_time, shader.timer + dt);
end

function interface.startDraw(shader)
    love.graphics.setShader(shader.shader);
    shader.shader:send(timer_name, shader.timer / shader.max_time);
end

function interface.finishDraw()
    love.graphics.setShader();
end

function interface.reset(shader, time)
    shader.timer = time;
end

return (interface);