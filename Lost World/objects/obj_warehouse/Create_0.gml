output_dir = _dir;
input_dirs = [dir.down];

image_speed = 0;

// when you place a warehouse make them more expensive so you have to think about where to place them
obj_manager.building_costs[buildings.warehouse][items.wood] += 20;

function can_add_item(item, _input_dir){
	if (item != items.water) {
		return array_contains(input_dirs, _input_dir);
	}
	return false;
}

function add_item(item, _input_dir){
	obj_manager.inv_items[item[0]]++;
}

function get_data() {
	return {
		_dir: _dir,
	};
}