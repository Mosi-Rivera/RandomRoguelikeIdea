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

function interface.isCollidableTile(map, x, y)
    x, y = math.floor(x / map.tile_width) + 1, math.floor(y / map.tile_height) + 1;
    if x < 1 or x > map.width or y < 1 or y > map.height or map.data.collidable[(y - 1) * map.width + x] == nil then
        return (true);
    end
    return (false);
end

function interface.draw(map, camera, character)
    local tmx, tmy, ox, oy = camera_interface.cameraPositionToTileCoords(camera);
    local _, py = camera_interface.positionToTileCoords(camera, character.x, character.y);
    local tile;
    local data = map.data;
    local floor = data.floor;
    local decorations = data.decorations;
    local width = map.width;
    local spritesheet = map.spritesheet;
    local tile_width = map.tile_width;
    local tile_height = map.tile_height;
    local start_x = math.max(tmx, 1);
    local finish_x = math.min(map.width, tmx + camera.tiles_per_screen_width);
    
    for y = math.max(tmy, 1), py do
        for x = start_x, finish_x do
            tile = floor[(y - 1) * width + x];
            if tile then
                drawTile((x - tmx) * tile_width - ox, (y - tmy) * tile_height - oy, tile, spritesheet);
            end
            tile = decorations[(y - 1) * width + x];
            if tile then
                drawTile((x - tmx) * tile_width - ox, (y - tmy) * tile_height - oy - 8, tile, spritesheet);
            end
        end
    end
    drawable.draw(
        character,
        character.x - (tmx - 1) * tile_width - ox,
        character.y - (tmy - 1) * tile_height - oy
    );
    for y = py + 1, math.min(map.height, tmy + camera.tiles_per_screen_height) do
        for x = start_x, finish_x do
            tile = floor[(y - 1) * width + x];
            if tile then
                drawTile((x - tmx) * tile_width - ox, (y - tmy) * tile_height - oy, tile, spritesheet);
            end
            tile = decorations[(y - 1) * width + x];
            if tile then
                drawTile((x - tmx) * tile_width - ox, (y - tmy) * tile_height - oy - 8, tile, spritesheet);
            end
        end
    end
end

return (interface);