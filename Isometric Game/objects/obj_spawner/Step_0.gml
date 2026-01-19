spawn_timer++;

if (spawn_timer > spawn_dur && array_length(inv_items) = 0){
	spawn_timer = 0;
	var _new_item = [spawn_item, MIDDLE[0], MIDDLE[1]];
	array_push(inv_items, _new_item);
}

move_items();