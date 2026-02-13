output_dir = _dir;
//input_dirs = [dir.up, dir.right, dir.down, dir.left];

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

water_level = 0;
water_chance = 0.01;
range = obj_manager.sprinkler_radius;

image_speed = 0;

function can_add_item(item, _input_dir){
	return item == items.wood or item == items.iron
}

function add_item(item, _input_dir){
	water_level++;
}

function get_data() {
	return {
		_dir: _dir,
	};
}