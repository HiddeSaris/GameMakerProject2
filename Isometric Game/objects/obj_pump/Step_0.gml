spawn_timer++;

var back = _dir-2;
if (back < 0) {back += 4;}
var offset = dir_to_move(back);
var tile = [grid_x + offset[0], grid_y + offset[1]];
var in_water = obj_manager.ds_hydration_index[# tile[0], tile[1]] == 1;
if (spawn_timer > spawn_dur && array_length(inv_items) == 0 && in_water){
	spawn_timer = 0;
	var _new_item = [spawn_item, MIDDLE[0], MIDDLE[1]];
	array_push(inv_items, _new_item);
}

move_items();