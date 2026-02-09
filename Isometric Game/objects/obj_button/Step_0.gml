if (mouse_check_button_released(mb_left) //&& global.can_click 
&& point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_click = false;
	image_index = 0;
	if (button == -1){
		show_message("Button type variable not set: -1");
	}
	else if (!building_button){
		if (not global.main_menu && not obj_pause_manager.tablet_on){
			switch button{
				case buttons.nav_close:
					obj_manager.building_state = building_states.selecting;
					hide_build_menu();
				break;
				case buttons.nav_open:
					show_build_menu();
				break;
			}	
		}
	}
	else{
		obj_manager.selected_building = button;
		obj_manager.building_state = building_states.building;
	}
}

if (mouse_check_button_pressed(mb_left) //&& global.can_click 
&& point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_click = false;	
	image_index = 1;
}