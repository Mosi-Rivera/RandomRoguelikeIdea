local scenes;
local scene;
local methods = {};

function methods.onenter()
	scene.onenter();
end

function methods.onexit()
	scene.onexit();
	scene.dispose();
end

function methods.update(dt)
	scene.update(dt);
end

function methods.draw()
	scene.draw();
end

function methods.setScene(key)
	scene.dispose();
	scene = scenes[key];
end

function methods.init(scenes, default_scene)
	scenes = scenes;
	scene = scenes[default_scene];
	methods.onenter();
end

return (methods);
