local card_manager = require('combat.card_system.card_manager');
local character_data = require('overworld.data.character_data');
local enemy_data = require('overworld.data.enemy_data');
local character = require('combat.characters.character');
local event_interface = require('combat.combat_system.event');
local card = require('combat.card_system.card');
local grid = require('combat.grid_system.grid');
local interface = {};
local player_character;
local events = event_interface.newManager();

function interface.init(enemies)
    enemies = enemies or {};
    grid.init();
    card_manager.init(card.dataTableToCardTable(RUN_INTERFACE.get().cards));
    player_character = grid.addCharacter(
        2,
        2,
        character.new(character_data[RUN_INTERFACE.get().character]),
        true
    );
    for k, v in pairs(enemies) do
        grid.addCharacter(
            3 + (k - 1) % 3 + 1,
            math.floor((k - 1) / 3) + 1,
            character.new(enemy_data[v])
        );
    end
    MOVE_MANAGER.init();
    ATTACK_MANAGER.init();
end

function interface.getCharacter()
    return (player_character);
end

function interface.update(dt)
    card_manager.update(dt);
    grid.update(dt);
    event_interface.update(events, dt);
    MOVE_MANAGER.update(dt);
    ATTACK_MANAGER.update(dt);
end

function interface.draw()
    grid.draw();
    event_interface.draw(events);
    card_manager.draw();
end

function interface.dispose()
    grid.dispose();
    card_manager.dispose();
end

function interface.getEvents()
    return (events);
end

return (interface);