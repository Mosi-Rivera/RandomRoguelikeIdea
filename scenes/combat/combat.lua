local combat_system = require('combat.combat_system.combat_system');
local scene = {};

function scene.onenter()
    combat_system.init({
        [5] = 1
    });
end

function scene.onexit()

end

function scene.update(dt)
    combat_system.update(dt);
end

function scene.draw()
    SCALE_MANAGER.start();
    combat_system.draw();
    SCALE_MANAGER.finish();
end

function scene.dispose()
    combat_system.dispose();
end

return (scene);