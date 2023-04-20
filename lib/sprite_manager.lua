local sprites = {};
local quads = {};
local sprite_manager = {};

function sprite_manager.addSprite(key, src)
    if not sprites[key] then
        sprites[key] = love.graphics.newImage(src);
        return (sprites[key]);
    end
end

function sprite_manager.addQuads(sprite_key, quads_key, w, h)
    local img = sprites[sprite_key];
    if (not img) then return end;
    local result = {};
    local img_w, img_h = img:getDimensions();
    local ix = math.floor(img_w / w);
    local iy = math.floor(img_h / h);
    for y = 0, iy - 1 do
        for x = 0, ix - 1 do
            table.insert(result, love.graphics.newQuad(x * w, y * h, w, h, img_w, img_h));
        end
    end
    quads[quads_key] = result;
end

function sprite_manager.getSprite(key)
    return (sprites[key]);
end

function sprite_manager.getQuads(key)
    return (quads[key]);
end

function sprite_manager.loadAtlas(src)
    local atlas = love.filesystem.load(src)();
    local data;
    local quad;
    local quad_table;
    local sprite;
    local img_w, img_h;
    for i = 1, #atlas do
        data = atlas[i];
        sprite = sprite_manager.addSprite(data.name, data.src);
        if sprite then
            if data.width and data.height then
                sprite_manager.addQuads(data.name, data.name, data.width, data.height);
            end
            if data.quads then
                if not quads[data.name] then
                    quads[data.name] = {};
                end
                quad_table = quads[data.name];
                img_w, img_h = sprite:getDimensions();
                for i = 1, #data.quads do
                    quad = data.quads[i];
                    table.insert(quad_table, love.graphics.newQuad(quad.x, quad.y, quad.width, quad.height, img_w, img_h));
                end 
            end
        end
    end
end

return (sprite_manager);