switch (button_id)
{
	case 0: // Resume
		layer_set_visible("MainuiLayer", true)
		global.resume_button_pressed = true;
	break;
	
	case 1: // Settings
		layer_set_visible("PauseLayer", false)
		layer_set_visible("SettingsLayer", true)
	break;
	
	case 2: // Quit
		game_end()
	break;
	
	case 3: // Back from Settings
		layer_set_visible("PauseLayer", true)
		layer_set_visible("SettingsLayer", false)
	break;
	
	case 4: // Resume from MM
		var succes = obj_manager.load_latest();
		if (not succes) {
			// no save found
		}
		layer_set_visible("MainuiLayer", true)
		layer_set_visible("MMSettingsLayer", false)
		layer_set_visible("MMLoadGameLayer", false)
		layer_set_visible("Main_menuLayer", false)
		layer_set_visible("MainuiLayer", true)
		global.main_menu = false;
	break;
	
	case 5: // New Game
		global.current_save = 0;
		for (var i = 1; i <= 6; i++) {
			if (!file_exists("SaveGame" + string(i) + ".json")) {
				global.current_save = i;
			}
		}
		obj_manager.new_seed();
		obj_manager.create_terrain();
		layer_set_visible("MainuiLayer", true)
		layer_set_visible("MMSettingsLayer", false)
		layer_set_visible("MMLoadGameLayer", false)
		layer_set_visible("Main_menuLayer", false)
		global.main_menu = false;
	break;
	
	case 6: // Load Game
		layer_set_visible("MMSettingsLayer", false)
		layer_set_visible("MMLoadGameLayer", true)
	break;
	
	case 7: // MM settings
		layer_set_visible("MMLoadGameLayer", false)
		layer_set_visible("MMSettingsLayer", true)
	break;
	
	case 8: // Back From MM Settings
		layer_set_visible("MMSettingsLayer", false)
	break;
	
	case 9: // Back From MM Load Game
		layer_set_visible("MMLoadGameLayer", false)
	break;
	
	case 10: // Back to MM
		layer_set_visible("MainuiLayer", false)
		global.main_menu = true;
		global.resume_button_pressed = true
		layer_set_visible("Main_menuLayer", true)
		obj_manager.save("SaveGame" + string(global.current_save) + ".json")
	break;
}