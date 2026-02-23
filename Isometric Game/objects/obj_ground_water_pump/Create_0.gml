output_dir = _dir;
input_dir = [];

image_speed = 0;
image_index = 0;

dir_coords = [UP, RIGHT, DOWN, LEFT];

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

update_timer = 0;
update_dur = 15;
done = false;

tiles = [[grid_x, grid_y]];

function contains(arr, val) {
	for (var i = 0; i < array_length(arr); i++) {
		if (array_equals(arr[i], val)) {
			return true;
		}
	}
	return false;
}

function can_add_item(item, _input_dir){
	return false;
}

function get_data() {
	return {
		_dir : _dir,
		tiles: tiles,
	}
}

function update_flood() {
	var tile = tiles[0];
	array_delete(tiles, 0, 1);
	show_debug_message(string(tile))
	obj_manager.ds_hydration_index[# tile[0], tile[1]] = 1;
	obj_manager.update_surface = true;
	
	// check neighboring tiles, and if can be filled add to queue to fill later
	var offsets = [[0, 1], [1, 0], [0, -1], [-1, 0]];
	for (var i = 0; i < 4; i++) {
		var offset = offsets[i];
		var new_tile = [tile[0]+offset[0], tile[1]+offset[1]]
		// if outside map continue to next
		if (clamp(new_tile[0], 0, hcells) != new_tile[0] or clamp(new_tile[1], 0, vcells) != new_tile[1]) {
			continue;
		}
		// if already in queue, continue to next
		if (contains(tiles, new_tile)) {
			continue;
		}
		if (obj_manager.ds_data[# new_tile[0], new_tile[1]] <= obj_manager.sea_level &&
			obj_manager.ds_hydration_index[# new_tile[0], new_tile[1]] == 0)
		{
			array_push(tiles, new_tile);
		}
	}
}
