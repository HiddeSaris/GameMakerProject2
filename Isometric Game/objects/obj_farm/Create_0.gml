output_dir = real(_dir);
input_dir = [(output_dir-1)%4, (output_dir+1)%4];

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

inv_items = [];
conveyor_speed = 0.06;
dist_items = 8.05;

num_gardens = 0;
water_level = 0;

// 1 seed per 30 seconds per garden with a 1.0x to 2.0x multiplier with water (0 - 10 water)
spawn_timer = 10 * 60;
spawn_dur = 30 * 60;
spawn_item = items.seed;

dir_coords = [UP, RIGHT, DOWN, LEFT];

image_speed = 0;
image_index = output_dir;

if (output_dir == dir.up or output_dir == dir.left) {
	depth = -grid_to_pos_y(grid_x+1, grid_y);
}
depth += 5

if (num_gardens == -1){
	reload_gardens();
}

function reload_gardens() {
	num_gardens = 0;
	var area = farm_get_area(grid_x, grid_y, obj_manager.farm_radius);
	for (var i = 0; i < array_length(area); i++) {
		var pos = area[i];
		var _building = obj_manager.ds_buildings[# pos[0], pos[1]];
		if (_building[0] == buildings.garden) {
			num_gardens++;
		}
	}
}

function add_garden(_x, _y) {
	num_gardens++;
}

function remove_garden(_x, _y) {
	num_gardens--;
}

function get_data() {
	return {
		_dir : _dir,
		num_gardens : num_gardens,
	}
}

function can_add_item(item, _input_dir){
	if (item != items.water) return false;
	if (water_level >= 10) return false;
	return item_can_move([items.water, dir_coords[_input_dir][0], dir_coords[_input_dir][1]]) and array_contains(input_dir, _input_dir);
}

function add_item(item, _input_dir){
	if (item[0] == items.water) {
		water_level++;
	}
	else {
		array_push(inv_items, [item[0], dir_coords[_input_dir][0], dir_coords[_input_dir][1]]);
	}
}

function item_can_move(item){
	var _x = item[1];
	var _y = item[2];
	
	for (var j=0; j<array_length(inv_items); j++){
		var _item = inv_items[j];
		
		if (item == _item){
			continue;
		}
		var _xx = _item[1];
		var _yy = _item[2];
		
		if (item_collision(_x, _y, _xx, _yy, dist_items, output_dir)){
			return false;
		}
	}
	return true;
}

function move_items(){
	for (var i=array_length(inv_items)-1; i>=0; i--){
		var item = inv_items[i];
		var _x = item[1];
		var _y = item[2];
		
		var _x_goal = dir_coords[output_dir][0];
		var _y_goal = dir_coords[output_dir][1];
		
		if (not item_can_move(item)){ // should not be necessary because it only has one item
			continue;
		}
		
		inv_items[i][1] += move_item_x(_x, _y, output_dir, conveyor_speed);
		inv_items[i][2] += move_item_y(_x, _y, output_dir, conveyor_speed);
		
		if (_x == _x_goal && _y == _y_goal){
			var _grid_x = pos_to_grid_x(x, y+5);
			var _grid_y = pos_to_grid_y(x, y+5);
			
			var _dif = dir_to_move(output_dir);
			
			var _next_conveyor = obj_manager.ds_buildings[# _grid_x + _dif[0], _grid_y + _dif[1]];
			var _next_conveyor_input = (output_dir+2) % 4
			
			var is_conveyor_building = array_contains(conveyor_buildings, _next_conveyor[0]);
			
			if (is_conveyor_building && _next_conveyor[1].can_add_item(spawn_item, _next_conveyor_input)){
				show_debug_message(string(_grid_x) + ", " + string(_grid_y))
				_next_conveyor[1].add_item(item, _next_conveyor_input);
				array_delete(inv_items, i, 1);
			}
		}
	}
}