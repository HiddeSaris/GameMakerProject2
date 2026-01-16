// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function dir_to_move(_dir){
	if (_dir == dir.up){
		return [0, -1];
	}
	if (_dir == dir.right){
		return [1, 0];
	}
	if (_dir == dir.down){
		return [0, 1];
	}
	if (_dir == dir.left){
		return [-1, 0];
	}
}

function grid_to_pos_x(_x, _y){

	return (_x - _y) * (iso_width / 2);
}

function grid_to_pos_y(_x, _y){

	return (_x + _y) * (iso_height / 2);
}

function pos_to_grid_x(_x, _y){
    var _grid_x = floor(((_x / (iso_width * 0.5)) + (_y / (iso_height * 0.5))) * 0.5);
	return clamp(_grid_x, 0, hcells - 1);
}

function pos_to_grid_y(_x, _y){
    var _grid_y = floor(((_y / (iso_height * 0.5)) - (_x / (iso_width * 0.5))) * 0.5);
	return clamp(_grid_y, 0, vcells - 1);
}

function can_build(_building, _x1, _y1, _x2 = _x1, _y2 = _y1){
	
	var _can_build = true;
	
	for (var _xx=min(_x1, _x2); _xx <= max(_x1, _x2); _xx++){
		for (var _yy=min(_y1, _y2); _yy <= max(_y1, _y2); _yy++){
			
			var height = obj_manager.ds_data[# _xx, _yy];
			//var m_index = ed.ds_mineable_index[# _xx, _yy];
			
			if (height < obj_manager.sea_level){
				return false;
			}
			
			var _room_x = grid_to_pos_x(_xx, _yy);
			var _room_y = grid_to_pos_y(_xx, _yy);
			
			var object = obj_manager.ds_buildings[# _xx, _yy];
			
			var can_place_on_conveyor = [buildings.conveyor, buildings.spawner];
			
			if (object[0] != buildings.NONE 
				and (object[0] != buildings.conveyor or not array_contains(can_place_on_conveyor, _building)) ){
				
				return false;
			}
		}
	}
	
	return true;
}

function build(_x, _y, _building, _dir){
	
	if (not can_build(_building, _x, _y)){
		return;
	}
	var x_beg = -1;
	var y_beg = -1;
	var x_size = -1;
	var y_size = -1;
	switch (_dir){
	case dir.up:
		x_beg = _x + placement_building[_building][0] - size_buildings[_building][0];
		y_beg = _y + placement_building[_building][1] - size_buildings[_building][1];
		x_size = size_buildings[_building][0];
		y_size = size_buildings[_building][1];
	break;
	case dir.right:
		x_beg = _x + 1 - placement_building[_building][1];
		y_beg = _y + 1 - placement_building[_building][0];
		x_size = size_buildings[_building][1];
		y_size = size_buildings[_building][0];
	break;
	case dir.down:
		x_beg = _x + 1 - placement_building[_building][0];
		y_beg = _y + 1 - placement_building[_building][1];
		x_size = size_buildings[_building][0];
		y_size = size_buildings[_building][1];
	break;
	case dir.left:
		x_beg = _x + placement_building[_building][1] - size_buildings[_building][1];
		y_beg = _y + placement_building[_building][0] - size_buildings[_building][0];
		x_size = size_buildings[_building][1];
		y_size = size_buildings[_building][0];
	break;
	}
	for (var _xx = x_beg; _xx < x_beg + x_size; _xx++){
		for (var _yy = y_beg; _yy < y_beg + y_size; _yy++){
			
			var object = obj_manager.ds_buildings[# _x, _y]
			if (object[0] != buildings.NONE){
				destroy_building(_xx, _yy);
			}
			if (_xx == _x and _yy == _y){
				var _room_x = grid_to_pos_x(_x, _y);
				var _room_y = grid_to_pos_y(_x, _y);
				obj_manager.ds_buildings[# _x, _y] = [ _building, instance_create_depth(_room_x, _room_y, -_room_y, object_buildings[_building], {_dir: _dir}), {}];
			}
			else{
				obj_manager.ds_buildings[# _xx, _yy] = [ buildings.ref,  [_x, _y], {}]
				show_debug_message(string(_xx) + string(_yy));
			}
		}
	}
}

function destroy_building(_x, _y) {
	var _building = obj_manager.ds_buildings[# _x, _y];
	if (_building[0] != buildings.ref) {
		instance_destroy(_building[1]);
	}
	else {
		var pos = _building[1];
		var building = obj_manager.ds_buildings[# pos[0], pos[1]];
		var size = size_buildings[building[0]];
		for (var _xx = pos[0]; _xx < pos[0] + size[0]; _xx++){
			for (var _yy = pos[1]; _yy < pos[1] + size[1]; _yy++){
				obj_manager.ds_buildings[# _xx, _yy] = [buildings.NONE, 0, {}];
			}
		}
	}
}

function mine(_x, _y){
	var _object = obj_manager.ds_buildings[# _x, _y];
	
	switch (_object[0]){
		case buildings.tree:
			instance_destroy(_object[1]);
			obj_manager.ds_buildings[# _x, _y] = [buildings.NONE, 0];
			obj_manager.inv_items[items.wood]++;
		break;
	}
	
	obj_manager.update_surface = true;
}