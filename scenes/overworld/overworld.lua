local proc_gen = require('overworld.proc_gen.gen');
local enemy_data = require('overworld.data.enemy_data');
local scene = {};
local overworld_manager = require('overworld.overworld_manager');

function scene.onenter()
    overworld_manager.init(RUN_INTERFACE.get().seed);
end

function scene.onexit()

end

function scene.update(dt)
    overworld_manager.update(dt);
end

function scene.draw()
    -- SCALE_MANAGER.start();
    overworld_manager.draw();
    -- SCALE_MANAGER.finish();
end

function scene.dispose()
    overworld_manager.dispose();
end

return (scene);