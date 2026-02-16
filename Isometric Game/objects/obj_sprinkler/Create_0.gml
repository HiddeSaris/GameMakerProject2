output_dir = _dir;
//input_dirs = [dir.up, dir.right, dir.down, dir.left];

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

water_level = 0;
water_chance = 0.01;
range = obj_manager.sprinkler_radius;

image_speed = 0;

//ParticleSystem
var _ps = part_system_create_layer(layer_get_id("Particles"), false);
part_system_draw_order(_ps, true);

//Emitter
var _ptype1 = part_type_create();
part_type_shape(_ptype1, pt_shape_pixel);
part_type_size(_ptype1, 1, 1, 0, 0);
part_type_scale(_ptype1, 2, 1);
part_type_speed(_ptype1, 0.7, 0.7, 0, 0);
part_type_direction(_ptype1, 0, 360, 0, 0);
part_type_gravity(_ptype1, 0.005, 270);
part_type_orientation(_ptype1, 0, 0, 0, 0, true);
part_type_colour3(_ptype1, $FFB200, $FF1900, $FF1900);
part_type_alpha3(_ptype1, 1, 0, 0);
part_type_blend(_ptype1, false);
part_type_life(_ptype1, 300, 300);

var _pemit1 = part_emitter_create(_ps);
part_emitter_region(_ps, _pemit1, -0.5, 0.5, -0.5, 0.5, ps_shape_ellipse, ps_distr_gaussian);
part_emitter_stream(_ps, _pemit1, _ptype1, 4);

part_system_position(_ps, x, y - 56);


function can_add_item(item, _input_dir){
	return item == items.water;
}

function add_item(item, _input_dir){
	water_level++;
}

function get_data() {
	return {
		_dir: _dir,
	};
}