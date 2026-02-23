var succes = obj_manager.load("SaveGame" + string(playbutton_id+1) + ".json");

if (succes == false) { 
	obj_manager.new_seed(); // create new world
	obj_manager.create_terrain();
}

global.current_save = playbutton_id+1;

layer_set_visible("MMLoadGameLayer", false)
layer_set_visible("Main_menuLayer", false)
layer_set_visible("MainuiLayer", true)
global.main_menu = false;