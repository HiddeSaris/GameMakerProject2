if (random(1) < water_chance && water_level > 0) {
	var _x = clamp(grid_x + irandom_range(-range, range), 0, hcells-1); // random pos nearby
	var _y = clamp(grid_y + irandom_range(-range, range), 0, vcells-1);
	
	if (point_distance(grid_x, grid_y, _x, _y) <= range) { // in circle
		if (obj_manager.ds_hydration_index[# _x, _y] == 0 && obj_manager.ds_data[# _x, _y] >= obj_manager.sea_level){
			obj_manager.ds_hydration_index[# _x, _y] = 1;
			obj_manager.update_draw_surface();
		}
	}
}

water_level--;

if (water_level <= 0) {
	part_emitter_stream(ps, pemit1, ptype1, 0);
}
else {
	part_emitter_stream(ps, pemit1, ptype1, 4);
}