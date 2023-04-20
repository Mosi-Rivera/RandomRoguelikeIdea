local interface = {};
local special_combinations = {
    [1] = 'basic',
    [2] = 'magic'
}
function interface.dataToFileNameStr(subtype, type)
    return ('attack_' .. subtype .. '_' .. type);
end

function interface.get(subtype, type)
    return (require('combat.attacks.basic.' .. interface.dataToFileNameStr(subtype, type)));
end

return (interface);