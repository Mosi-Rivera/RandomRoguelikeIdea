local proc_gen = require('overworld.proc_gen.gen');
local interface = {};

function interface.load()
    local run_data;
    local dead_enemies;
    local used_interactables;
    local map;
    local enemies;
    local interactables;

    run_data = RUN_INTERFACE.get();
    dead_enemies = run_data.dead_enemies;
    used_interactables = run_data.used_interactables;
    map =  proc_gen(run_data.seed + run_data.level);
    enemies = map.enemies;
    interactables = map.interactables;
    for i = 1, #dead_enemies do
        enemies[dead_enemies[i]] = nil;
    end
    for i = 1, #used_interactables do
        interactables[used_interactables[i]] = nil;
    end
    return (map);

end

return (interface);