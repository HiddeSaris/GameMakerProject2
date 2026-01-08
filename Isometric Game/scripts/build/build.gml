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
	
	var _grid_x = floor((mouse_x / iso_width) + (mouse_y / iso_height));
	return clamp(_grid_x, 0, hcells - 1);
}

function pos_to_grid_y(_x, _y){
	
	var _grid_y = floor((mouse_y / iso_height) - (mouse_x / iso_width));
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
			var objects_build = [];
			var objects_mine = [];
			
			array_copy(objects_build, 0, obj_manager.object_buildings, 0, array_length(obj_manager.object_buildings));
			array_pop(objects_build);
			
			var _inst_build = instance_position(_room_x, _room_y, objects_build);
			
			if (_inst_build != noone){
				return false;
			}
			
			if (_inst_build != noone && _building = buildings.conveyor && object_get_name(_inst_build.object_index) != "obj_conveyor"){
				return false;
			}
		}
	}
	
	return true;
}

function build(_x, _y, _building, _dir){
	
	var _room_x = grid_to_pos_x(_x, _y);
	var _room_y = grid_to_pos_y(_x, _y);
	
	if (can_build(_building, _x, _y)){
		
		var _inst = instance_position(_room_x, _room_y, all);
		instance_destroy(_inst)
		instance_create_depth(_room_x, _room_y, -_room_y, obj_manager.object_buildings[_building], {output_dir: _dir})
		obj_manager.ds_veg_index[# _x, _y] = 0;
	}
	else {
		// cannot build
	}
}

function mine(_x, _y){
	var _object = obj_manager.ds_buildings[# _x, _y];
	
	switch (_object){
		case buildings.tree:
			obj_manager.ds_buildings[# _x, _y] = 0;
		break;
	}
	
	obj_manager.update_draw_surface();
}