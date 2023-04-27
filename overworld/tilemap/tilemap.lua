local camera_interface = require('overworld.camera.camera');
local drawable = require('lib.drawable');
local interface = {};

local function drawTile(x, y, tile, spritesheet)
    SCALE_MANAGER.drawQuad(
        SPRITE_MANAGER.getSprite(spritesheet),
        SPRITE_MANAGER.getQuads(spritesheet)[tile],
        x,
        y
    );
end

function interface.coordIsCollidableTile(map, x, y)
    local data;
    local index;

    data = map.data;
    index = (y - 1) * map.width + x;
    if (
        x < 1 or x > map.width or
        y < 1 or y > map.height or
        data.collidable[index] == nil or
        data.enemies[index] or
        data.interactables[index]
    ) then
        return (true);
    end
    return (false);
end

function interface.isCollidableTile(map, x, y)
    return (interface.coordIsCollidableTile(
        math.floor(x / map.tile_width) + 1,
        math.floor(y / map.tile_height) + 1
    ));
end

local function drawRow(floor, decorations, enemies, interactables, x, y, index, spritesheet, tile_width, tile_height)
    local tile;

    tile = floor[index];
    if tile then
        drawTile(x, y, tile, spritesheet);
    end
    tile = decorations[index];
    if tile then
        drawTile(x, y - 8, tile, spritesheet);
    end
    tile = enemies[index];
    if tile then
        drawable.draw(tile, x + tile_width / 2, y + tile_height / 2);
    end
    tile = interactables[index];
    if tile then
        drawable.draw(tile, x + tile_width / 2, y + tile_height / 2);
    end
end

function interface.draw(map, camera, character)
    local tmx, tmy, ox, oy = camera_interface.cameraPositionToTileCoords(camera);
    tmx, tmy = math.max(1, tmx), math.max(tmy, 1);
    local tile;
    local data = map.data;
    local floor = data.floor;
    local decorations = data.decorations;
    local enemies = data.enemies;
    local interactables = data.interactables;
    local width = map.width;
    local spritesheet = map.spritesheet;
    local tile_width = map.tile_width;
    local tile_height = map.tile_height;
    local finish_x = math.min(map.width, tmx + camera.tiles_per_screen_width);

    for y = math.max(tmy, 1), character.y do
        for x = tmx, finish_x do
            drawRow(
                floor,
                decorations,
                enemies,
                interactables,
                (x - tmx) * tile_width - ox,
                (y - tmy) * tile_height - oy,
                (y - 1) * width + x,
                spritesheet,
                tile_width,
                tile_height
            );
        end
    end
    drawable.draw(
        character,
        math.floor((character.x - tmx + 0.5) * tile_width - ox + character.move_ox),
        math.floor((character.y - tmy + 0.5) * tile_height - oy + character.move_oy)
    );
    for y = character.y + 1, math.min(map.height, tmy + camera.tiles_per_screen_height) do
        for x = tmx, finish_x do
            drawRow(
                floor,
                decorations,
                enemies,
                interactables,
                (x - tmx) * tile_width - ox,
                (y - tmy) * tile_height - oy,
                (y - 1) * width + x,
                spritesheet,
                tile_width,
                tile_height
            );
        end
    end
end

return (interface);