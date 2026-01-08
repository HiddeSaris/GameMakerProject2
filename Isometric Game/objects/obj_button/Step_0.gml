var ui_flexpanels = layer_get_flexpanel_node("ui_build_menu")
var flexpanel = flexpanel_node_get_child(ui_flexpanels, "build_menu");				

if (mouse_check_button_released(mb_left) //&& global.can_click 
&& point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_click = false;
	image_index = 0;
	if (button == -1){
		show_message("Button type variable not set: -1");
	}
	else if (!building_button){
		switch button{
			case buttons.nav_close:
				obj_manager.building_state = building_states.selecting;
				hide_flexpanel(flexpanel);
			break;
			case buttons.nav_open:
				show_flexpanel(flexpanel);
			break;
		}	
	}
	else{
		obj_manager.selected_building = button;
		obj_manager.building_state = building_states.building;
		/*
		switch button{
			case buildings.conveyor:
				obj_manager.selected_building = buildings.conveyor;
			break;
		}
		*/
	}
}

if (mouse_check_button_pressed(mb_left) //&& global.can_click 
&& point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_click = false;	
	image_index = 1;
}