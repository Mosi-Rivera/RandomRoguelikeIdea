local tilemap = require('overworld.tilemap.tilemap');
local move_manager = require('overworld.move_manager.move_manager');
local ow_character_interface = require('overworld.character.character');
local camera_interface = require('overworld.camera.camera');
local interface = {};

function interface.new(key)
    return ({
            key = key,
    });
end

function interface.update(self, dt)
    local camera;
    local character;
    local map;

    camera = OVERWORLD_MANAGER.getCamera();
    character = OVERWORLD_MANAGER.getCharacter();
    map = OVERWORLD_MANAGER.getMap();
    move_manager.update(map, character, dt);
    ow_character_interface.update(character, dt);
    camera_interface.setPosition(
        camera,
        camera_interface.tileCoordsToPosition(
            camera,
            character.x - 1,
            character.y - 1,
            character.move_ox + math.floor(map.tile_width / 2),
            character.move_oy + math.floor(map.tile_height / 2)
        )
    );
end

function interface.draw()
    local camera;
    local character;
    local map;

    camera = OVERWORLD_MANAGER.getCamera();
    character = OVERWORLD_MANAGER.getCharacter();
    map = OVERWORLD_MANAGER.getMap();
    tilemap.draw(map, camera, character);
end

function interface.onenter()

end

function interface.onexit()

end

return (interface);