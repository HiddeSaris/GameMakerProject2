// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function move_item_x(_x, _y, out, _speed){
	
	var dir_coords = [global.up, global.right, global.down, global.left];
	
	var _x_goal = dir_coords[out][0];
	var _y_goal = dir_coords[out][1];
	
	var _diff_x = abs(_x - _x_goal);
	var _diff_y = abs(_y - _y_goal);
	
	if (abs(_diff_y*2 - _diff_x ) > 0.01){ // first to middle
		_x_goal = global.middle[0];
		_y_goal = global.middle[1];
	}
	
	if ( abs(_x_goal - _x) < abs(sign(_x_goal - _x) * 2 * _speed) ){ // almost at goal
			return _x_goal - _x;
		}
	else{
		return sign(_x_goal - _x) * 2 * _speed;
	}
}

function move_item_y(_x, _y, out, _speed){
	
	var dir_coords = [global.up, global.right, global.down, global.left];
	
	var _x_goal = dir_coords[out][0];
	var _y_goal = dir_coords[out][1];
	
	var _diff_x = abs(_x - _x_goal);
	var _diff_y = abs(_y - _y_goal);
	
	if (abs(_diff_y*2 - _diff_x) > 0.01){ // first to middle
		_x_goal = global.middle[0];
		_y_goal = global.middle[1];
	}
	
	if ( abs(_y_goal - _y) < abs(sign(_y_goal - _y) * _speed) ){ // almost at goal
			return _y_goal - _y;
		}
	else{
		return sign(_y_goal - _y) * _speed;
	}
}