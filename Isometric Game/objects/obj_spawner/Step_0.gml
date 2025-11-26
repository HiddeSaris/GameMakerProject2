// spawn timer
spawn_timer++;

if (spawn_timer > spawn_dur && array_length(inv_items) = 0){
	spawn_timer = 0;
	var _new_item = [spawn_item, global.middle[0], global.middle[1]];
	array_push(inv_items, _new_item);
}

// move items
for (var i=0; i<array_length(inv_items); i++){
	var item = inv_items[i];
	var _x = item[1];
	var _y = item[2];
	
	var _x_goal = dir_coords[output_dir][0];
	var _y_goal = dir_coords[output_dir][1];
	
	var _move_x = move_item_x(_x, _y, output_dir, conveyor_speed);
	var _move_y = move_item_y(_x, _y, output_dir, conveyor_speed);
	
	
	if (not item_can_move(item)){
		continue;
	}
	
	
	inv_items[i][1] += _move_x;
	inv_items[i][2] += _move_y;
	
	if (_x == _x_goal && _y == _y_goal){
		var _grid_x = pos_to_grid_x(x, y+5);
		var _grid_y = pos_to_grid_y(x, y+5);
		
		var _dif = dir_to_move(output_dir);
		
		var _next_conveyor = collision_point(grid_to_pos_x(_grid_x + _dif[0], _grid_y + _dif[1]), grid_to_pos_y(_grid_x + _dif[0], _grid_y + _dif[1]), obj_manager.conveyor_buildings, false, true);
		var _next_conveyor_input = (output_dir+2) % 4
		
		if (_next_conveyor != noone && array_contains(_next_conveyor.input_dir, _next_conveyor_input)){
			show_debug_message(string(_grid_x) + ", " + string(_grid_y))
			array_push(_next_conveyor.inv_items, [item[0], dir_coords[_next_conveyor_input][0], dir_coords[_next_conveyor_input][1]]);
			array_delete(inv_items, i, 1);
		}
		continue;
	}
}