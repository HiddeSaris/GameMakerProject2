#region VARS

grid_x = pos_to_grid_x(mouse_x, mouse_y);
grid_y = pos_to_grid_y(mouse_x, mouse_y);

var can_click_terrain = global.can_click;
var can_scroll = global.can_scroll

var mouse_l   = mouse_check_button(mb_left)&&can_click_terrain;
var mouse_r   = mouse_check_button(mb_right)&&can_click_terrain;
var mouse_p_l = mouse_check_button_pressed(mb_left)&&can_click_terrain;
var mouse_p_r = mouse_check_button_pressed(mb_right)&&can_click_terrain;
var mouse_r_l = mouse_check_button_released(mb_left)&&can_click_terrain;
var mouse_r_r = mouse_check_button_released(mb_right)&&can_click_terrain;

#endregion

#region CAN BUILD

if (building_conveyors){
	if (building_conveyors_dir){
		can_build_now = can_build(buildings.conveyor, building_conveyor_pos[0], building_conveyor_pos[1], grid_x, building_conveyor_pos[1]);
	}
	else{
		can_build_now = can_build(buildings.conveyor, building_conveyor_pos[0], building_conveyor_pos[1], building_conveyor_pos[0], grid_y);
	}
}
else{
	can_build_now = can_build(buildings.conveyor, grid_x, grid_y)
}

#endregion

#region CONTROLS

if (mouse_p_l && selected_building == buildings.conveyor){
	building_conveyors = true;
	building_conveyor_pos = [grid_x, grid_y];
	building_conveyors_dir = selected_dir;
}


if (mouse_r_l && building_conveyors_prev){
	if (building_state == building_states.building && can_build_now){
		if (building_conveyors_dir){
			var _len = grid_x - building_conveyor_pos[0]
			var _dir = -sign(_len) + 2;
			if (_len == 0){ _dir = selected_dir}
	
			for (var _x=min(grid_x, building_conveyor_pos[0]); _x <= max(grid_x, building_conveyor_pos[0]); _x++){
	
				var _y = building_conveyor_pos[1];
				var _room_x = grid_to_pos_x(_x, _y);
				var _room_y = grid_to_pos_y(_x, _y);
				
				build(_x, _y, buildings.conveyor, _dir)
			}
		}
		else{
			var _len = grid_y - building_conveyor_pos[1]
			var _dir = sign(_len) + 1;
			if (_len == 0){ _dir = selected_dir}
			
			for (var _y=min(grid_y, building_conveyor_pos[1]); _y <= max(grid_y, building_conveyor_pos[1]); _y++){
				
				var _x = building_conveyor_pos[0];
				var _room_x = grid_to_pos_x(_x, _y);
				var _room_y = grid_to_pos_y(_x, _y);
				
				build(_x, _y, buildings.conveyor, _dir)
			}
		}
	}
}

if (mouse_r_l or selected_building != buildings.conveyor){
	building_conveyors = false;
	building_conveyor_pos = [-1, -1]
}

if (mouse_p_l){
	if (building_state == building_states.building && !building_conveyors){
		build(grid_x, grid_y, selected_building, selected_dir);
	}
}

if keyboard_check_pressed(ord("R")){
	selected_dir++; 
	selected_dir = selected_dir % 4;
}

if keyboard_check_pressed(ord("E")){
	selected_building++;
	if (selected_building >= buildings.COUNT){
		selected_building = 0;
	}
}

if keyboard_check_pressed(ord("Q")){
	selected_building--;
	if (selected_building < 0){
		selected_building = buildings.COUNT-1;
	}
}

if keyboard_check_pressed(ord("K")){
	save();
}
if keyboard_check_pressed(ord("L")){
	load();
}

if keyboard_check_pressed(vk_escape){
	game_end();
}

#endregion

#region CAMERA

#region CONTROLS

var wheel = (mouse_wheel_down() - mouse_wheel_up())*can_scroll;

if (wheel != 0){

	wheel *= 0.1

	var add_width = cam_width * wheel;
	var add_height = cam_height * wheel;

	cam_width += add_width;
	cam_height += add_height;

	if (cam_width < max_cam_width && cam_width > min_cam_width){
		cam_x -= wheel * (mouse_x - cam_x);
		cam_y -= wheel * (mouse_y - cam_y);
		cam_goto_x -= wheel * (mouse_x - cam_goto_x);
		cam_goto_y -= wheel * (mouse_y - cam_goto_y);
	}
}


var _hor = ((keyboard_check(vk_right) or keyboard_check(ord("D"))) - (keyboard_check(vk_left) or keyboard_check(ord("A")))) * delta_time / game_get_speed(gamespeed_microseconds);
var _ver = ((keyboard_check(vk_down) or keyboard_check(ord("S"))) - (keyboard_check(vk_up) or keyboard_check(ord("W")))) * delta_time / game_get_speed(gamespeed_microseconds);

cam_goto_x = cam_goto_x + (_hor * cam_width / 109);
cam_goto_y = cam_goto_y + (_ver * cam_height / 123);
	
if (mouse_r){
	cam_x += (mouse_x_prev - mouse_x) * 0.5;
	cam_y += (mouse_y_prev - mouse_y) * 0.5;
	cam_goto_x += (mouse_x_prev - mouse_x) * 1.5;
	cam_goto_y += (mouse_y_prev - mouse_y) * 1.5;
}

#endregion

cam_width = clamp(cam_width, min_cam_width, max_cam_width);
cam_height = clamp(cam_height, min_cam_height, max_cam_height)

cam_x += (cam_goto_x - cam_x) / 10;
cam_y += (cam_goto_y - cam_y) / 18;

#region CAM BOUNDARIES

//left
if (cam_goto_x - cam_width/2 < -vcells * iso_width/2){cam_goto_x = -vcells*iso_width/2 + cam_width/2}
//right
if (cam_goto_x + cam_width/2 > hcells * iso_width/2){cam_goto_x = hcells*iso_width/2 - cam_width/2}
//top
if (cam_goto_y - cam_height/2 < 0){cam_goto_y = 0 + cam_height/2}
//bottom
if (cam_goto_y + cam_height/2 > (hcells+vcells) * (iso_height)/2){cam_goto_y = (hcells+vcells) * iso_height/2 - cam_height/2}

if (cam_width > (hcells + vcells)*iso_width/2){
	cam_goto_x = (hcells - vcells) * iso_width/4;
}
if (cam_height > (hcells + vcells)*iso_height/2){
	cam_goto_y = (hcells + vcells)*iso_height/4
}

#endregion


camera_set_view_size(view_camera[0], cam_width, cam_height) //updates camera size

camera_set_view_pos(view_camera[0], cam_x - cam_width/2, cam_y - cam_height/2); // update camera position


mouse_x_prev = mouse_x;
mouse_y_prev = mouse_y;

#endregion

building_conveyors_prev = building_conveyors;