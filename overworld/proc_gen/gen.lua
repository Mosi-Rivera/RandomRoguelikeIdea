local tiles = require('overworld.proc_gen.tiles');
local interactables_data = require('overworld.data.interactables_data');
local boss_data = require('overworld.data.boss_data');
local tile_width = 32;
local tile_height = 32;
local width = 50;
local height = 50;
local half_width = math.floor(width / 2);
local half_height = math.floor(height / 2);
local did_add_boss = false;
local boss;
local default_tiles = {
    collidable = 0,
    floor = tiles.ground_1,
    decorations = 0,
    overworld = 0
}

local function posToIndex(x, y)
    return (y - 1) * width + x;
end

local function calculateDistance(x1, y1, x2, y2, w, h)
    return math.sqrt((x2 - x1) ^ 2 * w + (y2 - y1) ^ 2 * h);
end

local function fillCollidable(map)
    local w, h = 1, 1;
    if math.random(1,2) == 1 then
        w = math.random(100, 300) / 100;
    else
        h = math.random(100, 300) / 100;
    end
    for y = 3, height - 4 do
        for x = 3, width - 4 do
            local distance = math.abs(calculateDistance(x, y, half_width, half_height, w, h));
            local prob = 100 * math.max(0, 1.25 - distance / half_width);
            if math.random(1, 100) <= prob then
                map[posToIndex(x,y)] = true;
            end
        end
    end
end


local function getTileAtPos(map, x, y)
    if x < 1 or x > width or y < 1 or y > height then return nil end
    return map[posToIndex(x, y)];
end

local function getWaterTile(collidable, floor, x, y)
    if getTileAtPos(collidable, x - 1, y) then
        if getTileAtPos(collidable, x + 1, y) then
            if getTileAtPos(collidable, x, y + 1) then
                return tiles.water_single_bottom;
            end
            return tiles.water_single_center;
        elseif getTileAtPos(collidable, x, y + 1) then
            return tiles.water_bottom_left;
        else
            return tiles.water_right;
        end
    elseif getTileAtPos(collidable, x + 1, y) then
        if getTileAtPos(collidable, x, y + 1) then
            return tiles.water_bottom_right;
        end
        return tiles.water_left;
    elseif getTileAtPos(collidable, x, y + 1) then
        return tiles.water_bottom;
    elseif not getTileAtPos(collidable, x, y - 1) then
        local left = getTileAtPos(collidable, x, y);
        local right = getTileAtPos(collidable, x, y);
        if left and right then
            return tiles.water_single_bottom_corners;
        elseif left then
            return tiles.water_bottom_left;
        elseif right then
            return tiles.water_bottom_right;
        end
    end
    return tiles.water;
end

local function fillWater(from, to, x, y)
    local index;

    index = posToIndex(x, y);
    if x < 1 or x > width or y < 1 or y > height or from[index] or to[index] ~= default_tiles.floor then return end
    to[index] = tiles.water;
    fillWater(from ,to, x + 1, y);
    fillWater(from ,to, x - 1, y);
    fillWater(from ,to, x, y + 1);
    fillWater(from ,to, x, y - 1);
end

local function getRandomCollidableDecoration()
    return tiles['land_obstacle_decoration_' .. math.random(1, 2)];
end

local function getLandTile(collidables, floor, x, y)
    local current_collidable = collidables[posToIndex(x, y)];
    local decoration = not current_collidable and getRandomCollidableDecoration() or nil;
    if current_collidable ~= collidables[posToIndex(x - 1, y)] then
        if current_collidable ~= collidables[posToIndex(x + 1, y)] then
            if current_collidable ~= collidables[posToIndex(x, y + 1)] then
                if current_collidable ~= collidables[posToIndex(x, y - 1)] then
                    return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.single_1 or tiles.vertical_top_1) or tiles.single_2), decoration;
                end
                return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.vertical_bottom_1 or tiles.vertical_center_1) or tiles.vertical_bottom_2), decoration;
            elseif current_collidable ~= collidables[posToIndex(x, y - 1)] then
                return (current_collidable and tiles.vertical_top_1 or tiles.vertical_top_2), decoration;
            end
            return (current_collidable and tiles.vertical_center_1 or tiles.vertical_center_2), decoration;
        elseif current_collidable ~= collidables[posToIndex(x, y + 1)] then
            if current_collidable ~= collidables[posToIndex(x, y - 1)] then
                return (current_collidable and  (floor[posToIndex(x, y + 1)] == tiles.water and tiles.horizontal_left_1 or tiles.top_left_corner_1) or tiles.horizontal_left_2), decoration;
            end
            return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.bottom_left_corner_1 or tiles.left_1) or tiles.bottom_left_corner_2), decoration;
        elseif current_collidable ~= collidables[posToIndex(x, y - 1)] then
            return (current_collidable and tiles.top_left_corner_1 or tiles.top_left_corner_2), decoration;
        else
            return (current_collidable and tiles.left_1 or tiles.left_2), decoration;
        end
    elseif current_collidable ~= collidables[posToIndex(x + 1, y)] then
        if current_collidable ~= collidables[posToIndex(x, y + 1)] then
            if current_collidable ~= collidables[posToIndex(x, y - 1)] then
                return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.horizontal_right_1 or tiles.top_right_corner_1) or tiles.horizontal_right_2), decoration;
            end
            return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.bottom_right_corner_1 or tiles.right_1) or tiles.bottom_right_corner_2), decoration;
        elseif current_collidable ~= collidables[posToIndex(x, y - 1)] then
            return (current_collidable and tiles.top_right_corner_1 or tiles.top_right_corner_2), decoration;
        end
        return (current_collidable and tiles.right_1 or tiles.right_2), decoration;
    elseif current_collidable ~= collidables[posToIndex(x, y + 1)] then
        if current_collidable ~= collidables[posToIndex(x, y - 1)] then
            return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.horizontal_center_1 or tiles.top_1) or tiles.horizontal_center_2), decoration;
        end
        return (current_collidable and (floor[posToIndex(x, y + 1)] == tiles.water and tiles.bottom_1 or tiles.grass_1) or tiles.bottom_2), decoration;
    elseif current_collidable ~= collidables[posToIndex(x, y - 1)] then
        return (current_collidable and tiles.top_1 or tiles.top_2), decoration;
    end
    return (tiles[(current_collidable and 'grass_' or 'ground_') .. math.max(1, math.random(1, 10) - 6)]), decoration;
end

local function getTile(collidables, floor, x, y)
    if floor[posToIndex(x, y)] == tiles.water then
        return (getWaterTile(collidables, floor, x, y));
    else
        return getLandTile(collidables, floor, x, y);
    end
end

local function fillNature(maps)
    local collidable = maps.collidable;
    local floor = maps.floor;
    local decorations = maps.decorations;
    local decoration;
    local tile;
    for y = 2, width - 3 do
        for x = 2, height - 3 do
            tile, decoration = getTile(collidable, floor, x, y);
            if tile ~= nil then
                floor[posToIndex(x, y)] = getTile(collidable, floor, x, y);
            end
            if decoration then
                decorations[posToIndex(x, y)] = decoration;
            end
        end
    end
end

local function getRandomEnemy(dist)
    if dist > 70 and math.random(1, 100) <= 25 then
        if not did_add_boss then
            did_add_boss = true;
            return 9900 + boss;
        else
            return 900 + math.random(1, #boss_data[boss].mini_bosses);
        end
    end
    return math.random(1, 3);
end

local function getRandomInteractable(dist)
    return (math.max(1, math.random(1,5 + #interactables_data) - 5));
end

local function fillEnemiesAndInteractables(maps, seen, x, y)
    local probability;
    local distance;
    local count = 0;

    if seen[posToIndex(x, y)] or not maps.collidable[posToIndex(x, y)] or x < 1 or x > width or y < 1 or y > height then return (0) end
    seen[posToIndex(x, y)] = true;
    count = count + fillEnemiesAndInteractables(maps, seen, x + 1, y);
    count = count + fillEnemiesAndInteractables(maps, seen, x - 1, y);
    count = count + fillEnemiesAndInteractables(maps, seen, x, y + 1);
    count = count + fillEnemiesAndInteractables(maps, seen, x, y - 1);
    distance = calculateDistance(x, y, half_width, half_height, 1, 1)
    probability = 100 * math.max(0, math.abs(distance) / (half_width - 3));
    if math.random(1, 100) <= probability - 10 and count == 0 then
        if math.random(1, 100) <= 100 - (distance / half_width) * 20 then
            maps.enemies[posToIndex(x, y)] = getRandomEnemy(probability);
        else
            maps.interactables[posToIndex(x, y)] = getRandomInteractable(probability);
        end
        return (1);
    end
    return (0);
end

return function(seed)
    math.randomseed(seed);
    did_add_boss = false;
    boss = math.random(1, #boss_data);
    local maps = {
        floor = {},
        decorations = {},
        overworld = {},
        collidable = {},
        enemies = {},
        interactables = {}
    };
    for _ = 1, width * height do
        table.insert(maps.floor, default_tiles.floor);
    end
    fillCollidable(maps.collidable);
    fillWater(maps.collidable, maps.floor, 1, 1);
    fillNature(maps);
    fillEnemiesAndInteractables(maps, {}, half_width, half_height);
    return {
        width = width,
        height = height,
        tile_width = tile_width,
        tile_height = tile_height,
        data = maps,
        spritesheet = boss_data[boss].spritesheets[math.random(1, #boss_data[boss].spritesheets)]
    }
end