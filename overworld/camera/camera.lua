local screen = require('config.screen');
local half_width = math.floor(screen.virtual_width / 2);
local half_height = math.floor(screen.virtual_height / 2);
local interface = {};

function interface.new(tile_width, tile_height)
    return ({
        x = 0,
        y = 0,
        tx = 0,
        ty = 0,
        tiles_per_screen_width = math.floor(screen.virtual_width / tile_width + 0.5),
        tiles_per_screen_height = math.floor(screen.vritual_height / tile_height + 0.5),
        tile_width = tile_width,
        tile_height = tile_height
    });
end

function interface.setTargetPosition(camera, x, y)
    camera.tx = x;
    camera.ty = y;
end

function interface.setPosition(camera, x, y)
    camera.x = x;
    camera.y = y;
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
            
        elseif camera.y < camera.ty then 
    
        end
    end
end

function interface.cameraPositionToTileCoords(camera)
    return math.max(math.floor(camera.x / camera.tile_width + 1 - half_width), 1), math.max(math.floor(camera.y / camera.tile_height + 1 - half_height), 1);
end

return (interface);