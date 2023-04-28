local interface = {};
local shaders;

function interface.init()
    local shaders_atlas;
    local data;

    shaders = {};
    shaders_atlas = love.filesystem.load('assets/shaders/atlas.lua')();
    for i = 1, #shaders_atlas do
        data = shaders_atlas[i];        
        shaders[data.key] = love.graphics.setShader(love.filesystem.read(data.src));
    end
end

function interface.getShader(key)
    return (shaders[key]);
end

function interface.setShader(key, src)
    shaders[key] = love.graphics.setShader(love.filesystem.read(src));
end

return (interface);