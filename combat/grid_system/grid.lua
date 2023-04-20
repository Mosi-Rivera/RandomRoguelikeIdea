local cell = require('combat.grid_system.cell');
local drawable = require('combat.characters.drawable');
local character = require('combat.characters.character');
local cell_w, cell_h = cell.getDimensions();
local width = 6;
local height = 3;
local data;
local allied_characters;
local enemy_characters;
local interface = {};

function interface.init()
    allied_characters = {};
    enemy_characters = {};
    data = {};
    for i = 1, width * height do
        table.insert(data, cell.new(i));
    end
end

function interface.getCell(x,y)
    if x < 1 or x > width or y < 1 or y > height then return nil end
    return (data[(y - 1) * width + x]);
end

function interface.update(dt)
    for i = 1, #allied_characters do
        character.update(allied_characters[i], dt);
    end
    for i = 1, #enemy_characters do
        character.update(enemy_characters[i], dt);
    end
    for i = 1, #data do
        cell.update(data[i], dt);
    end
end

function interface.getTilePosition(x, y)
    return 30 + cell_w * (x - 1),  100 + cell_h * (y - 1);
end

function interface.getCenteredTilePosition(x, y)
    x, y = interface.getTilePosition(x, y);
    return math.floor(x + cell_w / 2),  math.floor(y + cell_h / 2);
end

function interface.draw()
    local drawables = {};
    local cell_table;
    local drawable_data;
    for y = 1, height do
        for x = 1, width do
            cell_table = data[(y - 1) * width + x];
            local _x, _y = interface.getTilePosition(x, y);
            if cell_table.occupying then
                table.insert(drawables, {cell_table.occupying, _x + cell_w / 2, _y + cell_h / 2});
            end
            cell.draw(cell_table, _x, _y);
        end
    end
    for i = 1, #drawables do
        drawable_data = drawables[i];
        drawable.draw(
            drawable_data[1],
            drawable_data[2],
            drawable_data[3]
        );
    end
end

function interface.addCharacter(x, y, character, is_allied)
    local _cell = interface.getCell(x,y);
    print(x, y);
    if _cell and cell.addOccupying(_cell, character) then
        table.insert(is_allied and allied_characters or enemy_characters, character);
        return (character);
    end
    return (nil);
end

function interface.removeCharacter(index, is_allied)
    cell.removeOccupying(data[(is_allied and allied_characters or enemy_characters)[index].tile.index]);
    table.remove(is_allied and allied_characters or enemy_characters, index);
end

function interface.getAllies()
    return (allied_characters);
end

function interface.getEnemies()
    return (enemy_characters);
end

function interface.dispose()
    data = nil;
    allied_characters = nil;
    enemy_characters = nil;
end

return (interface);