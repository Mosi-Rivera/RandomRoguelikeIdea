local proc_gen = require('overworld.proc_gen.gen');
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
    love.graphics.scale(.8, .8)
    local floor = map.data.floor;
    local decorations = map.data.decorations;
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
        end
    end
end

function scene.dispose()
    map = nil;
end

return (scene);