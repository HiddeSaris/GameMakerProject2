#region VARS

grid_x = pos_to_grid_x(mouse_x, mouse_y);
grid_y = pos_to_grid_y(mouse_x, mouse_y);


var can_click_terrain = global.can_click && !global.main_menu && !obj_pause_manager.tablet_on;
var can_scroll = global.can_scroll && !global.main_menu && !obj_pause_manager.tablet_on;

var mouse_l   = mouse_check_button(mb_left)&&can_click_terrain;
var mouse_r   = mouse_check_button(mb_right)&&can_click_terrain;
var mouse_p_l = mouse_check_button_pressed(mb_left)&&can_click_terrain;
var mouse_p_r = mouse_check_button_pressed(mb_right)&&can_click_terrain;
var mouse_r_l = mouse_check_button_released(mb_left)&&can_click_terrain;
var mouse_r_r = mouse_check_button_released(mb_right)&&can_click_terrain;

#endregion

#region DEBUG VIEW

debug_fps = fps;
debug_fps_real = fps_real;
debug_num_instances = instance_number(all);
debug_building = ds_buildings[# grid_x, grid_y];

if (keyboard_check_pressed(ord("I"))){
	if (not dbg_view_exists(inspector)){
		inspector = dbg_view("Debug View", true, -1, -1, 200, 240);
		// section variables
		dbg_section("Variables");
	
		dbg_text("FPS:");
		dbg_same_line();
		dbg_text(ref_create(self, "debug_fps"));
		dbg_text("Real FPS:");
		dbg_same_line();
		dbg_text(ref_create(self, "debug_fps_real"));
	
		dbg_text("Instances:");
		dbg_same_line();
		dbg_text(ref_create(self, "debug_num_instances"));
	
		dbg_text("Seed:");
		dbg_same_line();
		dbg_text(ref_create(self, "seed"));
		
		dbg_text("save:");
		dbg_same_line();
		dbg_text(ref_create(global, "current_save"));
		
		dbg_text("Building:");
		dbg_same_line();
		dbg_text(ref_create(self, "debug_building"));
	
		dbg_text("Grid x:");
		dbg_same_line();
		dbg_text(ref_create(self, "grid_x"));
		dbg_text("Grid y:");
		dbg_same_line();
		dbg_text(ref_create(self, "grid_y"));
	
		dbg_text("Gui width:");
		dbg_same_line();
		dbg_text(ref_create(self, "gui_width"));
		dbg_text("Gui height:");
		dbg_same_line();
		dbg_text(ref_create(self, "gui_height"));
		
		// section inventory
		dbg_section("Inventory");
		dbg_text_input(ref_create(self, "inv_items", items.wood), "Wood:", "i");
	}
	else {
		dbg_view_delete(inspector)
	}
}

#endregion

#region CAN BUILD

if (building_conveyors){
	if (building_conveyors_dir){
		can_build_now = can_build(buildings.conveyor, building_conveyor_pos[0], building_conveyor_pos[1], grid_x, building_conveyor_pos[1], selected_dir);
	}
	else{
		can_build_now = can_build(buildings.conveyor, building_conveyor_pos[0], building_conveyor_pos[1], building_conveyor_pos[0], grid_y, selected_dir);
	}
}
else{
	var beg_x, beg_y, size_x, size_y;
	switch (selected_building){	
	case buildings.lumberjack:
		beg_x = building_begin_x(grid_x, grid_y, buildings.lumberjack, selected_dir);
		beg_y = building_begin_y(grid_x, grid_y, buildings.lumberjack, selected_dir);
		size_x = size_buildings[buildings.lumberjack][selected_dir%2];
		size_y = size_buildings[buildings.lumberjack][(selected_dir+1)%2];
		can_build_now = can_build(selected_building, beg_x, beg_y, beg_x+size_x-1, beg_y+size_y-1, selected_dir)
	break;
	case buildings.farm:
		beg_x = building_begin_x(grid_x, grid_y, buildings.lumberjack, selected_dir);
		beg_y = building_begin_y(grid_x, grid_y, buildings.lumberjack, selected_dir);
		size_x = size_buildings[buildings.lumberjack][selected_dir%2];
		size_y = size_buildings[buildings.lumberjack][(selected_dir+1)%2];
		can_build_now = can_build(selected_building, beg_x, beg_y, beg_x+size_x-1, beg_y+size_y-1, selected_dir)
	break;
	case buildings.mineshack:
		beg_x = building_begin_x(grid_x, grid_y, buildings.mineshack, selected_dir);
		beg_y = building_begin_y(grid_x, grid_y, buildings.mineshack, selected_dir);
		size_x = size_buildings[buildings.mineshack][selected_dir%2];
		size_y = size_buildings[buildings.mineshack][(selected_dir+1)%2];
		can_build_now = can_build(selected_building, beg_x, beg_y, beg_x+size_x-1, beg_y+size_y-1, selected_dir)
	break;
	default:
		can_build_now = can_build(selected_building, grid_x, grid_y, grid_x, grid_y, selected_dir)
	break;
	}
}

#endregion

#region MINING

if (mining_coord[0] != grid_x or mining_coord[1] != grid_y){
	mining_time = 0;
	mining_coord = [grid_x, grid_y];
}

#endregion

#region CONTROLS

if (building_state == building_states.destroying) {
	cursor_sprite = spr_ui_icon3;
}
else {
	cursor_sprite = spr_cursor;
}

if (mouse_p_l && (selected_building == buildings.conveyor or selected_building == buildings.pipe)){
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
				
				build(_x, _y, selected_building, _dir)
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
				
				build(_x, _y, selected_building, _dir)
			}
		}
	}
}

if (mouse_p_l){
	switch (building_state)
	{
	case building_states.building:
		if (!building_conveyors){
			build(grid_x, grid_y, selected_building, selected_dir);
		}
	break;
	case building_states.selecting:
		
	break;
	case building_states.destroying:
		if (ds_buildings[# grid_x, grid_y][0] != buildings.tree){
			destroy_building(grid_x, grid_y);
		}
	break;
	}
}

if (mouse_l){
	switch (building_state)
	{
	case building_states.building:
		
	break;
	case building_states.selecting:
		if (mining_time >= mining_dur){
			mine(grid_x, grid_y)
			mining_time = 0;
		}
		else{
			mining_time++;
		}
	break;
	case building_states.destroying:
	
	break;
	}
}
else{
	mining_time = 0;
	mining_coord = [-1, -1]
}

if (mouse_r_l or (selected_building != buildings.conveyor and selected_building != buildings.pipe)){
	building_conveyors = false;
	building_conveyor_pos = [-1, -1]
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

if (keyboard_check_pressed(ord("X")) && !global.main_menu && !obj_pause_manager.tablet_on) {
	if (building_state == building_states.destroying)
		building_state = building_states.selecting;
	else 
		building_state = building_states.destroying;
}

if keyboard_check_pressed(ord("K")) && !global.main_menu && !obj_pause_manager.tablet_on{
	save();
}
if keyboard_check_pressed(ord("L")) && !global.main_menu && !obj_pause_manager.tablet_on{
	load();
}

#endregion

#region CAMERA

#region CONTROLS

var wheel = (mouse_wheel_down() - mouse_wheel_up())*can_scroll;

if (wheel != 0 && not global.main_menu && not obj_pause_manager.tablet_on){

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

if (not global.main_menu && not obj_pause_manager.tablet_on){
	cam_goto_x = cam_goto_x + (_hor * cam_width / 109);
	cam_goto_y = cam_goto_y + (_ver * cam_height / 123);
}
	
if (mouse_r && not global.main_menu && not obj_pause_manager.tablet_on){
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