grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

farm_min_pos = [-1, -1];
farm_min_dist = infinity;
farm = [];

update_farm_pos();

function update_farm_pos() {
	var old_pos = farm_min_pos;
	for (var i=0; i < array_length(obj_manager.farming_positions); i++) {
		var pos = obj_manager.farming_positions[i];
		var dist = point_distance(grid_x, grid_y, pos[0], pos[1]);
		if (dist <= farm_min_dist) {
			farm_min_dist = dist;
			farm_min_pos = pos;
		}
	}
	
	if (old_pos[0] != farm_min_pos[0] or old_pos[1] != farm_min_pos[1]) and old_pos[0] != -1{
		if (update_farm) {
			farm[1].remove_garden(grid_x, grid_y);
		}
	}
	
	if (farm_min_dist <= obj_manager.farm_radius) {
		farm = obj_manager.ds_buildings[# farm_min_pos[0], farm_min_pos[1]];
		if (update_farm){
			farm[1].add_garden(grid_x, grid_y); 
		}
	}
}

function get_data() {
	return {
		farm_min_pos: farm_min_pos,
		farm_min_dist: farm_min_dist,
		farm: farm,
		update_farm: false,
	}
}