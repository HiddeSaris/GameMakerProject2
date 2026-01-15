output_dir = real(output_dir);
input_dir = [];

image_speed = 0;
image_index = output_dir;

dist_items = 8.05;
conveyor_speed = 0.06;

spawn_timer = 0;
spawn_dur = 6 * 60;

spawn_item = items.wood;
inv_items = [];

dir_coords = [UP, RIGHT, DOWN, LEFT];



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

function can_add_item(_input_dir){
	return item_can_move([items.wood, dir_coords[_input_dir][0], dir_coords[_input_dir][1]]) and array_contains(input_dir, _input_dir);
}

function add_item(item, input_dir){
	array_push(inv_items, [item[0], dir_coords[input_dir][0], dir_coords[input_dir][1]]);
}

function get_data() {
	return {
		output_dir : output_dir,
		inv_items : inv_items,
	}
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
			
			if (is_conveyor_building && _next_conveyor[1].can_add_item(_next_conveyor_input)){
				show_debug_message(string(_grid_x) + ", " + string(_grid_y))
				_next_conveyor[1].add_item(item, _next_conveyor_input);
				array_delete(inv_items, i, 1);
			}
		}
	}
}
