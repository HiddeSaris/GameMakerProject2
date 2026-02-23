var scroll_up = mouse_wheel_up();
var scroll_down = mouse_wheel_down();

if ((scroll_up || scroll_down) && global.can_scroll && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_scroll = false
	var scroll = scroll_down - scroll_up;
	scroll_speed += scroll * scroll_acceleration;
}

if ((mouse_check_button_released(mb_left) || mouse_check_button_pressed(mb_left)) && global.can_click 
&& point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)){
	global.can_click = false;
}

scroll_speed *= 0.9;
scroll_value += scroll_speed;

var max_scroll = num_children * (node_width + gap_width) - gap_width - row_width + side_padding;

if (scroll_value < 0){
	scroll_value = 0;
	scroll_speed = 0;
}
else if (scroll_value > max_scroll){
	scroll_value = max(0, max_scroll)
	scroll_speed = 0;
}

flexpanel_node_style_set_position(fp_scroll_bar_nodes, flexpanel_edge.right, scroll_value, flexpanel_unit.point);
flexpanel_calculate_layout(fp_ui_layer, display_get_gui_width(), display_get_gui_height(), flexpanel_direction.LTR);
