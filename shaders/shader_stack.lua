local interface = {};
local new_canvas = love.graphics.newCanvas();

function interface.new(stack)
    return {
        disabled = {},
        stack = stack,

    }
end

function interface.disable(stack, index)
    stack.disabled[index] = true;
end

function interface.enable(stack, index)
    stack.disabled[index] = nil;
end

function interface.update(stack)
    local disabled;
    local shader_data;

    disabled = stack.disabled;
    stack = stack.stack;
    for i = 1, #stack do
        if not disabled[i] then
            shader_data = stack[i];
            shader_data.interface.update(shader_data);
        end
    end
end

function interface.draw(stack)
    local disabled;
    local shader_data;
    local shader_interface;
    local swap_count;

    local canvases = {new_canvas, love.graphics.getCanvas()}
    disabled = stack.disabled;
    stack = stack.stack;
    for i = 1, #stack do
        if not disabled[i] then
            shader_data = stack[i];
            shader_interface = shader_data.interface;
            love.graphics.setCanvas(canvases[1]);
            love.graphcs.clear();
            shader_interface.startDraw(shader_data);
            love.graphics.draw(canvases[2]);
            canvases[1], canvases[2] = canvases[2], canvases[1];
            swap_count = swap_count + 1;
            shader_interface.finishdraw(shader_data);
        end
    end
    love.graphics.setCanvas();
    if swap_count % 2 == 1 then
        love.graphics.draw(canvases[2]);
    end
end

return (interface);