require('globals');
COMBAT_SCENE = require('scenes.combat.combat');
OVERWORLD_SCENE = require('scenes.overworld.overworld');

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest');
    RUN_INTERFACE.load();
    SPRITE_MANAGER.loadAtlas('assets/atlas/spritesheets.lua');
    SCALE_MANAGER.init();
	SCENE_MANAGER.init({
        OVERWORLD_SCENE,
        COMBAT_SCENE
    }, 1);
    KEYBOARD_MANAGER.init(require('config.bindings'));
end

function love.resize(w, h)
    SCALE_MANAGER.resize(w, h);
end

function love.keypressed(k)
    KEYBOARD_MANAGER.onpressevent(k);
end

function love.keyreleased(k)
    KEYBOARD_MANAGER.onreleaseevent(k);
end

function love.update(dt)
    SCENE_MANAGER.update(dt);
    KEYBOARD_MANAGER.update();
end

function love.draw()
    SCALE_MANAGER.drawStartPrep();
    SCENE_MANAGER.draw();
    SCALE_MANAGER.drawFinishPrep();
end