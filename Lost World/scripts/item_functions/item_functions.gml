// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function is_on_diagonal(_x, _y, _x_goal, _y_goal){
	var _diff_x = abs(_x - _x_goal);
	var _diff_y = abs(_y - _y_goal);
	
	return abs(_diff_y*2 - _diff_x ) < 0.01;
}

function move_item_x(_x, _y, out, _speed){
	
	var dir_coords = [UP, RIGHT, DOWN, LEFT];
	
	var _x_goal = dir_coords[out][0];
	var _y_goal = dir_coords[out][1];
	
	if (not is_on_diagonal(_x, _y, _x_goal, _y_goal)){ // first to middle
		_x_goal = MIDDLE[0];
		_y_goal = MIDDLE[1];
	}
	
	if ( abs(_x_goal - _x) < abs(sign(_x_goal - _x) * 2 * _speed) ){ // almost at goal
			return _x_goal - _x;
		}
	else{
		return sign(_x_goal - _x) * 2 * _speed;
	}
}

function move_item_y(_x, _y, out, _speed){
	
	var dir_coords = [UP, RIGHT, DOWN, LEFT];
	
	var _x_goal = dir_coords[out][0];
	var _y_goal = dir_coords[out][1];
	
	if (not is_on_diagonal(_x, _y, _x_goal, _y_goal)){ // first to middle
		_x_goal = MIDDLE[0];
		_y_goal = MIDDLE[1];
	}
	
	if ( abs(_y_goal - _y) < abs(sign(_y_goal - _y) * _speed) ){ // almost at goal
			return _y_goal - _y;
		}
	else{
		return sign(_y_goal - _y) * _speed;
	}
}

function is_in_same_iso_square(x1, y1, x2, y2, height){
	return abs(2*y1 - x1 - 2*y2 + x2) < height and abs(2*y1 + x1 - 2*y2 - x2) < height;
}

function item_collision(x_self, y_self, x_other, y_other, min_dist, _dir){
	var dir_coords = [UP, RIGHT, DOWN, LEFT];
	
	var _diff_x = abs(x_self - x_other);
	var _diff_y = abs(y_self - y_other);
	
	if (not is_in_same_iso_square(x_self, y_self, x_other, y_other, 2*min_dist)){
		return false; // no collision
	}
	var on_diag_self  = is_on_diagonal(x_self , y_self , dir_coords[_dir][0], dir_coords[_dir][1]);
	var on_diag_other = is_on_diagonal(x_other, y_other, dir_coords[_dir][0], dir_coords[_dir][1]);
	
	var dist_to_end_self;
	var dist_to_end_other;
	
	if (on_diag_self){ // dist to end
		dist_to_end_self = abs(x_self - dir_coords[_dir][0]);
	}
	else { // dist to middle then end
		dist_to_end_self = abs(x_self - MIDDLE[0]) + abs(MIDDLE[0] - dir_coords[_dir][0]);
	}
	
	if (on_diag_other){ // dist to end
		dist_to_end_other = abs(x_other - dir_coords[_dir][0]);
	}
	else { // dist to middle then end
		dist_to_end_other = abs(x_other - MIDDLE[0]) + abs(MIDDLE[0] - dir_coords[_dir][0]);
	}
	
	if (dist_to_end_self > dist_to_end_other){
		return true; // collision
	}
	return false; // collision but self is in front so don't stop
	
}