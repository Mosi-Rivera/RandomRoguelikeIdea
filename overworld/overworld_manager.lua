local proc_gen = require('overworld.proc_gen.gen');
local camera_interface = require('overworld.camera.camera');
local tilemap = require('overworld.tilemap.tilemap');
local interface = {};
local map;
local camera;

function interface.init(seed)
    map = proc_gen(seed);
    camera = camera_interface.new(map.tile_width, map.tile_height, map.width, map.height);
    camera_interface.setPosition(camera, math.floor(map.width / 2) * 32, math.floor(map.height / 2) * 32);
    print(camera.tiles_per_screen_width, camera.tiles_per_screen_height)
end

function interface.isInitialized()
    return (map and camera);
end

function interface.dispose()
    map = nil;
    camera = nil;
end

function interface.draw()
    tilemap.draw(map, camera);
end

function interface.update(dt)
    if KEYBOARD_MANAGER.isDown('right') then
        camera_interface.setPosition(camera, camera.x + 1, camera.y);
    elseif KEYBOARD_MANAGER.isDown('left') then
        camera_interface.setPosition(camera, camera.x - 1, camera.y);
    elseif KEYBOARD_MANAGER.isDown('up') then
        camera_interface.setPosition(camera, camera.x, camera.y - 1);
    elseif KEYBOARD_MANAGER.isDown('down') then
        camera_interface.setPosition(camera, camera.x, camera.y + 1);
    end
end

return (interface);