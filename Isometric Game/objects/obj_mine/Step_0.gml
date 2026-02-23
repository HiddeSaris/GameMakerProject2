spawn_timer++;

if (spawn_timer > spawn_dur && array_length(inv_items) == 0){
	spawn_timer = 0;
	var _new_item = [spawn_item, MIDDLE[0], MIDDLE[1]];
	array_push(inv_items, _new_item);
	
}

move_items();


if (random(1) < pollute_chance) {
	var _x = grid_x + irandom_range(-pollute_range, pollute_range);
	var _y = grid_y + irandom_range(-pollute_range, pollute_range);
	
	obj_manager.ds_hydration_index[# _x, _y] = 0;
	obj_manager.update_draw_surface();
}