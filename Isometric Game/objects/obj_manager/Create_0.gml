#region EXTRA VARIABLES

randomise();

show_debug_overlay(false, false);
inspector = undefined;
debug_fps = fps;
debug_fps_real = fps_real;
debug_num_instances = instance_number(all);
debug_building = [];

gui_width = 1920//960;
gui_height = 1080//540;

hide_build_menu();

display_set_gui_size(gui_width, gui_height);
cursor_sprite = spr_cursor;

global.can_scroll = true;
global.can_click = true;

seed = irandom(65535); 
random_set_seed(seed);
seed_x =  seed & 0b0000000011111111; // get first 8 bits of seed
seed_y = (seed & 0b1111111100000000) >> 8; // get second 8 bits of seed and add bitwise right

function new_seed(s = irandom(65535)){
	seed = s; 
	random_set_seed(seed);
	seed_x =  seed & 0b0000000011111111; // get first 8 bits of seed
	seed_y = (seed & 0b1111111100000000) >> 8; // get second 8 bits of seed and add bitwise right
}

octaves = 4;
frequency = 0.04;

#macro hcells 150
#macro vcells 150
#macro iso_width 32 // width of the top of the spr_iso_floor (minus 2 because of stacking)
#macro iso_height 16 // height of the top of the spr_iso_floor (minus 1 because of stacking)

grid_x = pos_to_grid_x(mouse_x, mouse_y); //Where is the mouse on the grid?
grid_y = pos_to_grid_y(mouse_x, mouse_y); //Where is the mouse on the grid?

sea_level = 30;
tree_level = 60;

surface_tiles = -1; // surface for all tiles to draw them all at once for performance
update_surface = false;

cam_width = camera_get_view_width(view_camera[0]);
cam_height = camera_get_view_height(view_camera[0]); 
min_cam_width = 160;
min_cam_height = 90;
max_cam_width = max(hcells, vcells) * 32;
max_cam_height = max(hcells, vcells) * 18;
cam_x = 1.6;
cam_y = 0.9 + min(hcells, vcells)/2 * iso_height;
cam_goto_x = cam_x;
cam_goto_y = cam_y;
mouse_x_prev = mouse_x;
mouse_y_prev = mouse_y;

inv_items = array_create(items.COUNT, 0);

can_build_now = true;

building_conveyors = false;
building_conveyors_prev = false;
building_conveyor_pos = [-1, -1];
building_conveyors_dir = 0;

building_state = building_states.selecting;
selected_building = buildings.spawner;
selected_dir = dir.up

mining_dur = 60;
mining_time = 0;
mining_coord = [-1, -1];

farming_positions = [];
farm_radius = 6;

sprinkler_radius = 6;

#macro UP [11, -2] // conveyor input/output positions
#macro RIGHT [3, 6] // relative to sprite origin
#macro DOWN [-5, 6]
#macro LEFT [-13, -2]
#macro MIDDLE [-1, 4]

#macro sprite_items [spr_wood, spr_wood, spr_seed, spr_wood]
#macro sprite_buildings [spr_spawner, spr_conveyor, spr_plumding, spr_warehouse, spr_lumberjackshack,  spr_seedshack, spr_farmshack, spr_garden, spr_plumbshack, spr_tree, spr_mineshack, spr_beeshack]
#macro object_buildings [obj_spawner, obj_conveyor, obj_pipe,     obj_warehouse, obj_lumberjack_shack, obj_forester,  obj_farm    ,  obj_garden, obj_pump,       obj_tree, obj_mine,      obj_sprinkler]
#macro size_buildings     [[1, 1],     [1, 1],       [1, 1],      [1, 1],         [1, 2],              [1, 2],        [1, 2],        [1, 1],     [1, 1],         [1, 1],   [3, 4],        [1, 1]]
#macro placement_building [[1, 1],     [1, 1],       [1, 1],      [1, 1],         [1, 2],              [1, 2],        [1, 2],        [1, 1],     [1, 1],         [1, 1],   [2, 4],        [1, 1]]
#macro conveyor_buildings [buildings.conveyor, buildings.warehouse, buildings.farm, buildings.pipe, buildings.forester] // buildings that can input items

enum building_states{
	selecting,
	building,
	destroying,
}

enum buildings{
	
	spawner,
	conveyor, 
	pipe,
	warehouse,
	lumberjack,
	forester,
	farm,
	garden,
	pump,
	tree,
	mineshack,
	sprinkler,
	COUNT,
	ref,
	NONE,
}

enum items{
	wood,
	iron,
	seed,
	water,
	COUNT,
	NONE,
}

enum dir{
	up,
	right,
	down,
	left,
}

#endregion

#region SETUP GRID

ds_data = ds_grid_create(hcells, vcells);
ds_hydration_index = ds_grid_create(hcells, vcells);
ds_veg_index = ds_grid_create(hcells, vcells);
ds_buildings = ds_grid_create(hcells, vcells);

function update_draw_surface(){
	var surface_w = (hcells + vcells) * iso_width/2;
	var surface_h = (hcells + vcells+2) * iso_height/2;

	if (!surface_exists(surface_tiles)) // setup tile surface
	{
	    surface_tiles = surface_create(surface_w, surface_h);
	}
	surface_set_target(surface_tiles);
	draw_clear_alpha(c_black, 0);
	
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
			
			var height = ds_data[# _xx, _yy];
			var _veg_index = ds_veg_index[# _xx, _yy];
			var _hydration_index = ds_hydration_index[# _xx, _yy];
			var _building = ds_buildings[# _xx, _yy];
			
			var _draw_x = grid_to_pos_x(_xx, _yy) + surface_w/2;
			var _draw_y = grid_to_pos_y(_xx, _yy);
			
			
			if (height < sea_level){
				if (_hydration_index == 1) {
					draw_sprite(spr_water, 0, _draw_x, _draw_y);
				}
				else {
					draw_sprite(spr_water, 1, _draw_x, _draw_y);
				}
			}
			else{
				if (_hydration_index == 1) {
					draw_sprite(spr_grass, 0, _draw_x, _draw_y);
				}
				else {
					draw_sprite(spr_grass, 2, _draw_x, _draw_y);
				}
			}
			
			if (_building[0] == buildings.NONE && _hydration_index == 1){
				draw_sprite(spr_vegitation, _veg_index, _draw_x, _draw_y);
			}
		}
	}
	
	surface_reset_target();
}

function create_terrain(){
	remove_objects();
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
		
			var _result = 0.0;
			var _amplitude = 0.5;
			var _freq = frequency;
			
			repeat(octaves){
				_result += _amplitude * perlin_noise(_xx * _freq + seed_x, _yy * _freq + seed_y);
				
				_amplitude *= 0.5;
				_freq *= 2;
			}
			
			_result += 0.5; // -0.5 <-> 0.5 to 0 <-> 1
			_result *= 100
			
			ds_data[# _xx, _yy] = _result; 
			ds_hydration_index[# _xx, _yy] = 0;
			
			var _veg_height = (_result - sea_level) / (100 - sea_level);
			var _veg_variance = 0.5;
			
			if (_result > sea_level && irandom(100) < 65){
				ds_veg_index[# _xx, _yy] = (sqrt(_veg_height) + random(_veg_variance)) * sprite_get_number(spr_vegitation) * ds_hydration_index[# _xx, _yy];
			}
			else {
				ds_veg_index[# _xx, _yy] = 0;
			}
			
			var room_x = grid_to_pos_x(_xx, _yy);
			var room_y = grid_to_pos_y(_xx, _yy);
			
			if (_result>=tree_level && random(1) < 0.5){
				ds_buildings[# _xx, _yy] = [buildings.tree, instance_create_depth(room_x, room_y, -room_y, obj_tree, {_dir: 0, alive: false}), {}];
			}
			else {
				ds_buildings[# _xx, _yy] = [buildings.NONE, 0, {}];
			}
		}
	}
	update_draw_surface();
}

function get_building(_x, _y){
	var _building = ds_buildings[# _x, _y];
	var _type = _building[0];
	
	if (_type != buildings.ref){
		return _building;
	}
	
	var _xx = _building[1][0];
	var _yy = _building[1][1];
	
	return ds_buildings[# _xx, _yy];
}

function remove_objects(){
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
			var _object = ds_buildings[# _xx, _yy];
			if (_object == 0){
				return;
			}
			if (_object[0] != buildings.NONE and _object[0] != buildings.ref){
				instance_destroy(ds_buildings[# _xx, _yy][1]);
			}
			ds_buildings[# _xx, _yy] = [buildings.NONE, 0];
		}
	}
}

function save_objects(){
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
			var _object = ds_buildings[# _xx, _yy];
			if (_object[0] != buildings.NONE and _object[0] != buildings.ref){
				var _data = _object[1].get_data();
				ds_buildings[# _xx, _yy][2] = _data;
			}
		}
	}
}

function load_objects(){
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
			
			var room_x = grid_to_pos_x(_xx, _yy);
			var room_y = grid_to_pos_y(_xx, _yy);
			
			var _object = ds_buildings[# _xx, _yy];
			if (_object[0] != buildings.NONE and _object[0] != buildings.ref){
				ds_buildings[# _xx, _yy][1] = instance_create_depth(room_x, room_y, -room_y, object_buildings[_object[0]], _object[2]);
			}
		}
	}
}

create_terrain();

#endregion

#region SAVE

function save(_filename = "savedata.json"){
	if (os_type == os_gxgames or os_browser != browser_not_a_browser){
		return false;
	}
	
	var _data = array_create(0);
	
	save_objects();
	
	var _data_manager = {
		Date : date_current_datetime(),
		Seed : seed,
		Inv_items : inv_items,
		farming_positions: farming_positions,
	}
	array_push(_data, _data_manager);
	array_push(_data, grid_to_struct(ds_data));
	array_push(_data, grid_to_struct(ds_hydration_index));
	array_push(_data, grid_to_struct(ds_veg_index));
	array_push(_data, grid_to_struct(ds_buildings));
	
	var _str_data = json_stringify(_data);
	var _buffer = buffer_create(string_byte_length(_str_data)+1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _str_data);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
	return true;
}

function save_get_date(_filename = "savedata.json"){
	if (os_type == os_gxgames or os_browser != browser_not_a_browser){
		return false;
	}
	var _buffer = buffer_load(_filename);
	if (_buffer == -1) {
		return false;
	}
	var _str_data = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	var _load_data = json_parse(_str_data);
	
	var _data_manager = _load_data[0];
	
	return _data_manager.Date;
}

function update_farms() {
	for (var i=0; i < array_length(farming_positions); i++) {
		var pos = farming_positions[i];
		var farm = ds_buildings[# pos[0], pos[1]];
		var inst;
		if (farm[0] == buildings.ref){
			inst = ds_buildings[# farm[1][0], farm[1][1]][1];
		}
		else {
			inst = farm[1]
		}
		inst.reload_gardens();
	}
}

function load(_filename = "savedata.json"){
	if (os_type == os_gxgames or os_browser != browser_not_a_browser){
		return false;
	}
	var _buffer = buffer_load(_filename);
	if (_buffer == -1) {
		return false;
	}
	var _str_data = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	var _load_data = json_parse(_str_data);
	
	remove_objects();
	
	var _data_manager = _load_data[0];
	
	var s = _data_manager.Seed;
	new_seed(s);
	building_state = building_states.selecting;
	
	inv_items = _data_manager.Inv_items;
	farming_positions = _data_manager.farming_positions;
	
	ds_grid_copy(ds_data, struct_to_grid(_load_data[1]));
	ds_grid_copy(ds_hydration_index, struct_to_grid(_load_data[2]));
	ds_grid_copy(ds_veg_index, struct_to_grid(_load_data[3]));
	ds_grid_copy(ds_buildings, struct_to_grid(_load_data[4]));
	
	update_draw_surface();
	load_objects();
	update_farms();
	return true;
}

function load_latest() {
	var latest = -1;
	var latest_date = date_create_datetime(2000, 1, 1, 1, 1, 1);
	for (var i = 1; i <= 6; i++) {
		var date = save_get_date("SaveGame" + string(i) + ".json");
		if date == false
			continue;
		
		if (date_compare_datetime(date, latest_date) == 1) {
			latest_date = date; // new latest
			latest = i;
		}
	}
	
	if (date_compare_datetime(latest_date, date_create_datetime(2000, 1, 1, 1, 1, 1)) != 0) {
		load("SaveGame" + string(latest) + ".json");
		global.current_save = latest;
		return true;
	}
	else {
		return false; // there is no save
	}
}

#endregion