local proc_gen = require('overworld.proc_gen.gen');
local enemy_data = require('overworld.data.enemy_data');
local scene = {};

function scene.onenter()
    OVERWORLD_MANAGER.init();
end

function scene.onexit()

end

function scene.update(dt)
    OVERWORLD_MANAGER.update(dt);
end

function scene.draw()
    SCALE_MANAGER.start();
    OVERWORLD_MANAGER.draw();
    SCALE_MANAGER.finish();
end

function scene.dispose()
    OVERWORLD_MANAGER.dispose();
end

return (scene);