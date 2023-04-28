local load_map = require('overworld.proc_gen.load_map');
local camera_interface = require('overworld.camera.camera');
local ow_character_interface = require('overworld.character.character');
local main_state = require('overworld.states.main');
local character_data = require('overworld.data.character_data');
local stack_state_manager_interface = require('lib.StackStateManager');
local interface = {};
local map;
local camera;
local character;
local stack_state_manager;

function interface.init()
    map = load_map.load();
    camera = camera_interface.new(map.tile_width, map.tile_height, map.width, map.height);
    character = ow_character_interface.new(character_data[1], math.floor(map.width / 2), math.floor(map.height / 2));
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
    stack_state_manager = stack_state_manager_interface.new({
        main = main_state
    }, 'main');
end

function interface.isInitialized()
    return (map and camera);
end

function interface.dispose()
    map = nil;
    camera = nil;
end

function interface.draw()
    stack_state_manager_interface.draw(stack_state_manager);
end

function interface.update(dt)
    stack_state_manager_interface.update(stack_state_manager, dt);
end

function interface.getCamera()
    return (camera);
end

function interface.getMap()
    return (map);
end

function interface.getCharacter()
    return (character);
end

return (interface);