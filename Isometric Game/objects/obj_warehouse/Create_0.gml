output_dir = real(_dir);
input_dirs = [dir.down];

image_speed = 0;

function can_add_item(item, _input_dir){
	if (item != items.wood or item != items.seed) return false;
	return array_contains(input_dirs, _input_dir);
}

function add_item(item, _input_dir){
	obj_manager.inv_items[item[0]]++;
}

function get_data() {
	return {
		_dir: _dir,
	};
}