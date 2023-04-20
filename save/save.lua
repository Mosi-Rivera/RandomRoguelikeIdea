local binser = require('lib.binser');
local interface = {};

function interface.save(name, ...)
    love.filesystem.write(name .. '.txt', binser.serialize(...));
    return data;
end

function interface.getInfo(name)
    return love.filesystem.getInfo(name .. '.txt', 'file');
end

function interface.exists(name)
    return (interface.getInfo(name) ~= nil);
end

function interface.load(name)
    if (interface.exists(name)) then
        local data,size = love.filesystem.read(name .. '.txt');
        return binser.deserialize(data);
    end
    return false;
end

return (interface);