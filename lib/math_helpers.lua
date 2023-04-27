local interface = {};

function interface.approach(a, b, c)
    if a < b then
        return (math.min(b, a + c));
    else
        return (math.max(b, a - c));
    end
end

function interface.sign(n)
    if n < 1 then 
        return (-1);
    else
        return (1);
    end
end

return (interface);