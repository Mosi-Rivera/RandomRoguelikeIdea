local save = require('save.save');
local run_interface = {};
local card = require('combat.card_system.card');
local C_FILE_NAME = 'run_data';
local run_data;

function run_interface.load()
    local data = save.load(C_FILE_NAME);
    if data then
        run_data = data;
    else
        local seed = os.time();
        local cards = {};
        math.randomseed(seed);
        for i = 0, 5 do
            table.insert(cards, card.new_data(math.floor(i / 2 + 1), math.floor(i / 3 + 1), math.random(0,9)));
        end
        print(INSPECT(cards));
        run_data = {
            seed = seed,
            cards = cards,
            character = 1
        }
    end
end

function run_interface.get()
    return (run_data);
end

return (run_interface);