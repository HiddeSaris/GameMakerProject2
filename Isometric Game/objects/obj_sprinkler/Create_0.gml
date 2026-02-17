output_dir = _dir;
//input_dirs = [dir.up, dir.right, dir.down, dir.left];

image_index = output_dir;

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

water_level = 0;
water_chance = 0.008;
range = obj_manager.sprinkler_radius;

image_speed = 0;

//ParticleSystem
ps = part_system_create_layer(layer_get_id("Particles"), false);
part_system_draw_order(ps, true);

//Emitter
ptype1 = part_type_create();
part_type_shape(ptype1, pt_shape_pixel);
part_type_size(ptype1, 1, 1, 0, 0);
part_type_scale(ptype1, 2, 1);
part_type_speed(ptype1, 0.7, 0.7, 0, 0);
part_type_direction(ptype1, 0, 360, 0, 0);
part_type_gravity(ptype1, 0.005, 270);
part_type_orientation(ptype1, 0, 0, 0, 0, true);
part_type_colour3(ptype1, $FFB200, $FF1900, $FF1900);
part_type_alpha3(ptype1, 1, 0, 0);
part_type_blend(ptype1, false);
part_type_life(ptype1, 300, 300);

pemit1 = part_emitter_create(ps);
part_emitter_region(ps, pemit1, -0.5, 0.5, -0.5, 0.5, ps_shape_ellipse, ps_distr_gaussian);
part_emitter_stream(ps, pemit1, ptype1, 4);

part_system_position(ps, x, y - 56);


function can_add_item(item, _input_dir){
	return item == items.water;
}

function add_item(item, _input_dir){
	water_level = 6 * 60;
}

function get_data() {
	return {
		_dir: _dir,
		water_level: water_level,
	};
}