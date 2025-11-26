output_dir = real(output_dir);
input_dir = [];

image_speed = 0;
image_index = output_dir;

dist_items = 5;
conveyor_speed = 0.03;

spawn_timer = 0;
spawn_dur = 2 * 60;

spawn_item = items.wood;
inv_items = [];

dir_coords = [global.up, global.right, global.down, global.left];



function item_can_move(item){
	
	for (var j=0; j<array_length(inv_items); j++){
		var _item = inv_items[j];
		
		if (array_equals(_item, item)){
			continue;
		}
		var _xx = _item[1];
		var _yy = _item[2];
		
		var _diff_x = abs(_x+_move_x - _xx);
		var _diff_y = abs(_y+_move_y - _yy);
		
		if (_diff_x < dist_items && _diff_y < dist_items){
			return false;
		}
	}
	return true;
}