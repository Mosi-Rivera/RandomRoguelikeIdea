local proc_gen = require('overworld.proc_gen.gen');
local camera_interface = require('overworld.camera.camera');
local tilemap = require('overworld.tilemap.tilemap');
local ow_character_interface = require('overworld.character.character');
local move_manager = require('overworld.move_manager.move_manager');
local interface = {};
local map;
local camera;
local character;

function interface.init(seed)
    map = proc_gen(seed);
    camera = camera_interface.new(map.tile_width, map.tile_height, map.width, map.height);
    character = ow_character_interface.init(1, math.floor(map.width / 2) * 32, math.floor(map.height / 2) * 32);
    camera_interface.setPosition(camera, character.x, character.y);
end

function interface.isInitialized()
    return (map and camera);
end

function interface.dispose()
    map = nil;
    camera = nil;
end

function interface.draw()
    tilemap.draw(map, camera, character);
end

function interface.update(dt)
    move_manager.update(map, character, dt);
    ow_character_interface.update(character, dt);
    camera_interface.setPosition(camera, character.x, character.y);
end

return (interface);