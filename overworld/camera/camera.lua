local screen = require('config.screen');
local half_width = math.floor(screen.virtual_width / 2);
local half_height = math.floor(screen.virtual_height / 2);
local interface = {};

function interface.new(tile_width, tile_height, map_width, map_height)
    print(math.floor(screen.virtual_width / tile_width + 0.5 + 1) * 32, math.floor(screen.virtual_height / tile_height + 0.5 + 1) * 32);
    return ({
        x = 0,
        y = 0,
        tx = 0,
        ty = 0,
        tiles_per_screen_width = math.floor(screen.virtual_width / tile_width + 0.5) + 1,
        tiles_per_screen_height = math.floor(screen.virtual_height / tile_height + 0.5) + 1,
        limit_x = (map_width * tile_width - half_width),
        limit_y = (map_height * tile_height - half_height),
        tile_width = tile_width,
        tile_height = tile_height
    });
end

function interface.setTargetPosition(camera, x, y)
    camera.tx = x;
    camera.ty = y;
end

function interface.setPosition(camera, x, y)
    camera.x = math.max(half_width, math.min(camera.limit_x, x));
    camera.y = math.max(half_height, math.min(camera.limit_y, y));
end

function interface.update(camera, dt)
    if camera.tx ~= camera.x then
        if camera.x > camera.tx then
            camera.x = math.min(camera.tx, camera.x + dt * 32);
        elseif camera.x < camera.tx then 
            camera.x = math.max(camera.tx, camera.x - dt * 32)
        end
    end
    if camera.ty ~= camera.y then
        if camera.y > camera.ty then
            camera.x = math.min(camera.ty, camera.y + dt * 32);
        elseif camera.y < camera.ty then 
            camera.x = math.max(camera.ty, camera.y - dt * 32)
        end
    end
end

function interface.cameraPositionToTileCoords(camera)
    local x = (camera.x - half_width) / camera.tile_width + 1;
    local y = (camera.y - half_height) / camera.tile_height + 1;
    local fx = math.floor(x);
    local fy = math.floor(y);
    return fx, fy, math.floor((x - fx) * camera.tile_width), math.floor((y - fy) * camera.tile_height);
end

function interface.positionToTileCoords(camera, x, y)
    x = x / camera.tile_width + 1;
    y = y / camera.tile_height + 1;
    return math.floor(x), math.floor(y);
end

return (interface);