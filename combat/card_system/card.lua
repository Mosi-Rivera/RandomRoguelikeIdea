local card = {};

function card.new(substype, type, cp)
    return ({
        cp = cp,
        type = type,
        subtype = substype
    });
end

local function getDataCp(data)
    return data % 10;
end

local function getDataType(data)
    data = math.floor(data / 10);
    return data % 10;
end

local function getDataSubtype(data)
    data = math.floor(data / 100);
    return data, data;
end

function card.dataToCard(data)
    return (card.new(
        (getDataSubtype(data)),
        (getDataType(data)),
        (getDataCp(data))
    ));
end

function card.dataTableToCardTable(data_table)
    local result = {};
    for i = 1, #data_table do
        table.insert(result, card.dataToCard(data_table[i]));
    end
    return (result);
end

function card.cardToData(card)
    local result = card.subtype;
    result = result * 10 + card.type;
    result = result * 10 + card.cp;
    return (result);
end

function card.new_data(subtype, type, cp)
    local result = subtype;
    result = result * 10 + type;
    result = result * 10 + cp;
    return (result);
end

return (card);