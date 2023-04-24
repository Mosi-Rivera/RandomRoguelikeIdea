local interface = {};

function interface.approach(a, b, c)
    if a < b then
        return (math.min(b, a + c));
    else
        return (math.max(b, a - c));
    end
end

return (interface);