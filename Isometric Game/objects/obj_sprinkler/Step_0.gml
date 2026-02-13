if (random(1) < water_chance) {
	var _x = grid_x + irandom_range(-range, range); // random pos nearby
	var _y = grid_y + irandom_range(-range, range);
	
	if (point_distance(grid_x, grid_y, _x, _y) <= range) { // in circle
		if (obj_manager.ds_hydration_index[# _x, _y] == 0 && obj_manager.ds_data[# _x, _y] >= obj_manager.sea_level){
			obj_manager.ds_hydration_index[# _x, _y] = 1;
			obj_manager.update_draw_surface();
		}
	}
}