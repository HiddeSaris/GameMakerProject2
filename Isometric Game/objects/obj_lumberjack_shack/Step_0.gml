chop_timer++;

if (chop_timer > chop_dur && array_length(inv_items) = 0){
	chop_timer = 0;
	if (chop_wood()){
		var _new_item = [spawn_item, MIDDLE[0], MIDDLE[1]];
		array_push(inv_items, _new_item);
	}
}

move_items();