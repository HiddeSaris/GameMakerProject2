#region EXTRA VARIABLES

randomise();
//show_debug_overlay(true, false)
display_set_gui_size(960, 540)
cursor_sprite = spr_cursor;

global.can_scroll = true;
global.can_click = true;

seed = irandom(65535); random_set_seed(seed);
seed_x = seed & 0b0000000011111111; // get first 8 bits of seed
seed_y = (seed & 0b1111111100000000) >> 8; // get second 8 bits of seed and add bitwise right

octaves = 4; //How big will the island be?
frequency = 0.03;

#macro hcells 150
#macro vcells 150
#macro iso_width 32 // width of the top of the spr_iso_floor (minus 2 because of stacking)
#macro iso_height 16 // height of the top of the spr_iso_floor (minus 1 because of stacking)

grid_x = 0; //Where is the mouse on the grid?
grid_y = 0; //Where is the mouse on the grid?

sea_level = 30;
tree_level = 60;

surface_tiles = -1; // surface for all tiles to draw them all at once for performance

cam_width = camera_get_view_width(view_camera[0]);
cam_height = camera_get_view_height(view_camera[0]); 
min_cam_width = 160;
min_cam_height = 90;
max_cam_width = max(hcells, vcells) * 32;
max_cam_height = max(hcells, vcells) * 18;
cam_x = 1.6;
cam_y = 0.9 + min(hcells, vcells)/2 * iso_height;
cam_goto_x = cam_x;
cam_goto_y = cam_y;
mouse_x_prev = mouse_x;
mouse_y_prev = mouse_y;

can_build_now = true;

building_conveyors = false;
building_conveyors_prev = false;
building_conveyor_pos = [-1, -1];
building_conveyors_dir = 0;

selected_building = buildings.spawner;
selected_dir = dir.up

global.up = [11, -2];
global.right = [3, 6];
global.down = [-5, 6];
global.left = [-13, -2];
global.middle = [-1, 4];

object_mineables = [obj_tree];
sprite_items = [spr_wood];
object_buildings = [obj_spawner, obj_conveyor];
conveyor_buildings = [obj_conveyor];

enum buildings{
	spawner,
	conveyor, 
	COUNT
}

enum mineables{
	tree,
	rock,
	COUNT
}

enum items{
	wood,
	stone,
	meat,
	fiber,
	iron,
}

enum dir{
	up,
	right,
	down,
	left,
}

#endregion


#region SETUP GRID

ds_data = ds_grid_create(hcells, vcells);
ds_hydration_index = ds_grid_create(hcells, vcells);
ds_veg_index = ds_grid_create(hcells, vcells);

function update_draw_surface(){
	var surface_w = (hcells + vcells) * iso_width/2;
	var surface_h = (hcells + vcells+2) * iso_height/2;

	if (!surface_exists(surface_tiles)) // setup tile surface
	{
	    surface_tiles = surface_create(surface_w, surface_h);
	}
	surface_set_target(surface_tiles);
	draw_clear_alpha(c_black, 0);
	
	for (var _yy = 0; _yy < vcells; _yy ++){
		for (var _xx = 0; _xx < hcells; _xx ++){
			
			var height = ds_data[# _xx, _yy];
			var _veg_index = ds_veg_index[# _xx, _yy];
			
			var _draw_x = grid_to_pos_x(_xx, _yy) + surface_w/2;
			var _draw_y = grid_to_pos_y(_xx, _yy);
			
			
			if (height < sea_level){
				draw_sprite(spr_water, 1, _draw_x, _draw_y);
			}
			else{
				draw_sprite(spr_dried_ground, 1, _draw_x, _draw_y);
			}
			
			draw_sprite(spr_vegitation, _veg_index, _draw_x, _draw_y)
		}
	}
	
	surface_reset_target();
}

for (var _yy = 0; _yy < vcells; _yy ++){
	for (var _xx = 0; _xx < hcells; _xx ++){
	
		var _result = 0.0;
		var _amplitude = 0.5;
		var _freq = frequency;
		
		repeat(octaves){
			_result += _amplitude * perlin_noise(_xx * _freq + seed_x, _yy * _freq + seed_y);
			
			_amplitude *= 0.5;
			_freq *= 2;
		}
		
		_result += 0.5; // -0.5 <-> 0.5 to 0 <-> 1
		_result *= 100
		
		ds_data[# _xx, _yy] = _result; 
		ds_hydration_index[# _xx, _yy] = 0
		
		ds_veg_index[# _xx, _yy] = max(0, irandom(1) * irandom(sprite_get_number(spr_vegitation) / 1 + irandom(1))) * (_result < tree_level && _result > sea_level) * ds_hydration_index[# _xx, _yy];
		
		var room_x = grid_to_pos_x(_xx, _yy);
		var room_y = grid_to_pos_y(_xx, _yy);
		
		if (_result>=60 && random(1) < 0.5){
			var tree = instance_create_depth(room_x, room_y, -room_y, obj_tree);
			tree.image_index = 1;
		}
		//ds_mineable_index[# _xx, _yy] = mineables.tree * (_result>=60 && random(1) < 0.5);
	}
}

update_draw_surface();

#endregion

