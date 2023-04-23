local camera_interface = require('overworld.camera.camera');
local interface = {};
local flag = false;

local function drawTile(x, y, tile, spritesheet)
    SCALE_MANAGER.drawQuad(
        SPRITE_MANAGER.getSprite(spritesheet),
        SPRITE_MANAGER.getQuads(spritesheet)[tile],
        x,
        y
    );
end
local flag = false;

function interface.draw(map, camera)
    love.graphics.scale(0.5,0.5);
    local tmx, tmy, ox, oy = camera_interface.cameraPositionToTileCoords(camera);
    local tile;
    local data = map.data;
    local floor = data.floor;
    local width = map.width;
    local spritesheet = map.spritesheet;
    local tile_width = map.tile_width;
    local tile_height = map.tile_height;
    for y = 1, map.height do
        for x = 1, map.width do
            tile = floor[(y - 1) * width + x];
            if tile then
                drawTile(360 + (x - 1) * tile_width, (y - 1) * tile_height, tile, spritesheet);
            end
        end
    end
    SCALE_MANAGER.drawRect(
        'line',
        360 + (tmx - 1) * 32 + ox,
        (tmy - 1) * 32 + oy,
        camera.tiles_per_screen_width * camera.tile_width,
        camera.tiles_per_screen_height * camera.tile_height
    );
    for y = math.max(tmy, 1), math.min(map.height, tmy + camera.tiles_per_screen_height + 1) do
        for x = math.max(tmx, 1), math.min(map.width, tmx + camera.tiles_per_screen_width + 1) do
            tile = floor[(y - 1) * width + x];
            if tile then
                drawTile((x - tmx) * tile_width - ox, (y - tmy) * tile_height - oy, tile, spritesheet);
            end
        end
    end
end

return (interface);