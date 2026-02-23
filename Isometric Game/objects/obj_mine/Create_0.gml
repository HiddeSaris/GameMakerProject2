output_dir = _dir;
input_dir = [];

image_speed = 0;
image_index = output_dir;

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

dist_items = 8.05;
conveyor_speed = 0.06;

pollute_chance = 0.01;
pollute_range = 7;

spawn_timer = 0;
spawn_dur = 6 * 60;

spawn_item = items.iron;
inv_items = [];

dir_coords = [UP, RIGHT, DOWN, LEFT];

//ParticleSystem
var _ps = part_system_create_layer(layer_get_id("Smoke_part"), false);
part_system_draw_order(_ps, true);

//smoke
var _ptype1 = part_type_create();
part_type_shape(_ptype1, pt_shape_smoke);
part_type_size(_ptype1, 0.2, 0.2, 0.01, 0);
part_type_scale(_ptype1, 1, 1);
part_type_speed(_ptype1, 1, 1, 0, 0);
part_type_direction(_ptype1, 80, 100, 0, 0);
part_type_gravity(_ptype1, 0.01, 0);
part_type_orientation(_ptype1, 0, 0, 0, 0, false);
part_type_colour3(_ptype1, $4B4B5E, $000000, $000000);
part_type_alpha3(_ptype1, 0.188, 0.161, 0);
part_type_blend(_ptype1, false);
part_type_life(_ptype1, 80, 180);

var _pemit1 = part_emitter_create(_ps);
part_emitter_region(_ps, _pemit1, -8, 8, -1.0625, 13.0625, ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(_ps, _pemit1, _ptype1, 1);

switch (output_dir) {
	case dir.up:
		part_system_position(_ps, x-36, y-10);
	break;
	case dir.right:
		part_system_position(_ps, x-54, y-54);
	break;
	case dir.down:
		part_system_position(_ps, x+52, y-54);
	break;
	case dir.left:
		part_system_position(_ps, x+34, y-10);
	break;
	}

function item_can_move(item){
	var _x = item[1];
	var _y = item[2];
	
	for (var j=0; j<array_length(inv_items); j++){
		var _item = inv_items[j];
		
		if (item == _item){
			continue;
		}
		var _xx = _item[1];
		var _yy = _item[2];
		
		if (item_collision(_x, _y, _xx, _yy, dist_items, output_dir)){
			return false;
		}
	}
	return true;
}

function can_add_item(item, _input_dir){
	return false;
}

function add_item(item, input_dir){
	array_push(inv_items, [item[0], dir_coords[input_dir][0], dir_coords[input_dir][1]]);
}

function get_data() {
	return {
		_dir : _dir,
		inv_items : inv_items,
	}
}

function move_items(){
	for (var i=array_length(inv_items)-1; i>=0; i--){
		var item = inv_items[i];
		var _x = item[1];
		var _y = item[2];
		
		var _x_goal = dir_coords[output_dir][0];
		var _y_goal = dir_coords[output_dir][1];
		
		if (not item_can_move(item)){ // should not be necessary because it only has one item
			continue;
		}
		
		inv_items[i][1] += move_item_x(_x, _y, output_dir, conveyor_speed);
		inv_items[i][2] += move_item_y(_x, _y, output_dir, conveyor_speed);
		
		if (_x == _x_goal && _y == _y_goal){
			var _grid_x = pos_to_grid_x(x, y+5);
			var _grid_y = pos_to_grid_y(x, y+5);
			
			var _dif = dir_to_move(output_dir);
			
			var _next_conveyor = obj_manager.ds_buildings[# _grid_x + _dif[0], _grid_y + _dif[1]];
			var _next_conveyor_input = (output_dir+2) % 4
			
			var is_conveyor_building = array_contains(conveyor_buildings, _next_conveyor[0]);
			
			if (is_conveyor_building && _next_conveyor[1].can_add_item(spawn_item, _next_conveyor_input)){
				show_debug_message(string(_grid_x) + ", " + string(_grid_y))
				_next_conveyor[1].add_item(item, _next_conveyor_input);
				array_delete(inv_items, i, 1);
			}
		}
	}
}
