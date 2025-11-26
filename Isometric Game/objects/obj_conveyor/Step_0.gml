for (var i=0; i<array_length(inv_items); i++){
	var item = inv_items[i];
	var _x = item[1];
	var _y = item[2];
	
	var _x_goal = dir_coords[output_dir][0];
	var _y_goal = dir_coords[output_dir][1];
	
	var skip = false;
	for (var j=0; j<array_length(inv_items); j++){
		var _item = inv_items[j];
		
		if (item == _item){
			continue;
		}
		var _xx = item[1];
		var _yy = item[2];
		
		var _diff_x = abs(_x - _xx);
		var _diff_y = abs(_y - _yy);
		
		if (_diff_x < dist_items && _diff_y < dist_items){
			skip = true;
			break;
		}
	}
	if (skip){
		continue;
	}
	
	inv_items[i][1] += move_item_x(_x, _y, output_dir, conveyor_speed);
	inv_items[i][2] += move_item_y(_x, _y, output_dir, conveyor_speed);
	
	if (_x == _x_goal && _y == _y_goal){
		
		continue;
	}
}