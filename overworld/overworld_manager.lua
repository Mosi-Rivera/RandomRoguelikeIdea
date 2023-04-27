local proc_gen = require('overworld.proc_gen.gen');
local camera_interface = require('overworld.camera.camera');
local tilemap = require('overworld.tilemap.tilemap');
local ow_character_interface = require('overworld.character.character');
local move_manager = require('overworld.move_manager.move_manager');
local character_data = require('overworld.data.character_data');
local interface = {};
local map;
local camera;
local character;

function interface.init(seed)
    map = proc_gen(seed);
    camera = camera_interface.new(map.tile_width, map.tile_height, map.width, map.height);
    character = ow_character_interface.new(character_data[1], math.floor(map.width / 2), math.floor(map.height / 2));
    print(INSPECT(character));
    camera_interface.setPosition(
        camera,
        camera_interface.tileCoordsToPosition(
            camera,
            character.x,
            character.y,
            math.floor(map.tile_width / 2),
            math.floor(map.tile_height / 2)
        )
    );
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
    camera_interface.setPosition(
        camera,
        camera_interface.tileCoordsToPosition(
            camera,
            character.x,
            character.y,
            character.move_ox + math.floor(map.tile_width / 2),
            character.move_oy + math.floor(map.tile_height / 2)
        )
    );
end

return (interface);