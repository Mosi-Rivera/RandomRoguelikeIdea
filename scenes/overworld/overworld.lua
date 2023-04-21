local proc_gen = require('overworld.proc_gen.gen');
local enemy_data = require('overworld.data.enemy_data');
local scene = {};
local map;

function scene.onenter()
    map = proc_gen(RUN_INTERFACE.get().seed);
end

function scene.onexit()

end

function scene.update(dt)

end

function scene.draw()
    love.graphics.scale(.35, .35)
    local floor = map.data.floor;
    local decorations = map.data.decorations;
    local enemies = map.data.enemies;
    local interactables = map.data.interactables;
    local width = map.width;
    local tile_width, tile_height = map.tile_width, map.tile_height;
    local tile;
    for y = 1, map.height do
        for x = 1, map.width do
            tile = floor[(y - 1) * width + x];
            if tile ~= 0 then
                love.graphics.draw(
                    SPRITE_MANAGER.getSprite('tileset1'),
                    SPRITE_MANAGER.getQuads('tileset1')[tile],
                    (x - 1) * tile_width,
                    (y - 1) * tile_height
                );
            end
            tile = decorations[(y - 1) * width + x];
            if tile then
                love.graphics.draw(
                    SPRITE_MANAGER.getSprite('tileset1'),
                    SPRITE_MANAGER.getQuads('tileset1')[tile],
                    (x - 1) * tile_width,
                    (y - 1) * tile_height - 8
                );
            end
            tile = enemies[(y - 1) * width + x];
            if tile then
                love.graphics.draw(
                    SPRITE_MANAGER.getSprite('ow_enemies'),
                    SPRITE_MANAGER.getQuads('ow_enemies')[tile],
                    (x - 1) * tile_width,
                    (y - 1) * tile_height - 12
                );
            end
            tile = interactables[(y - 1) * width + x];
            if tile then
                love.graphics.draw(
                    SPRITE_MANAGER.getSprite('ow_interactables'),
                    SPRITE_MANAGER.getQuads('ow_interactables')[tile],
                    (x - 1) * tile_width,
                    (y - 1) * tile_height - 12
                );
            end
        end
    end
end

function scene.dispose()
    map = nil;
end

return (scene);