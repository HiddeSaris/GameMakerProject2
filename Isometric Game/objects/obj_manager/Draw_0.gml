var surface_w = (hcells + vcells) * iso_width/2;
var surface_h = (hcells + vcells+2) * iso_height/2;

if (!surface_exists(surface_tiles)){
	update_draw_surface()
}
draw_surface(surface_tiles, -surface_w/2, 0);


var _draw_x = grid_to_pos_x(grid_x, grid_y);
var _draw_y = grid_to_pos_y(grid_x, grid_y);

// draw indicator
draw_sprite(spr_indicator, 0, _draw_x, _draw_y)

// draw preview
var col;
if (can_build_now){
	col = c_lime;
}
else {
	col = c_red;
}


if (mouse_check_button(mb_left)){
	if (building_conveyors){
		var _pos = building_conveyor_pos
		
		building_conveyors_dir = (abs(grid_x - _pos[0]) >= abs(grid_y - _pos[1]));
		
		if (grid_x == _pos[0] && grid_y == _pos[1]){
			draw_sprite_ext(spr_conveyor, selected_dir, _draw_x, _draw_y, 1, 1, 0, col, 1);
		}
		else if (building_conveyors_dir){ // x-direction
			var _len = grid_x - _pos[0]
			var _dir = -sign(_len) + 2;
			
			for (var _x=min(grid_x, _pos[0]); _x <= max(grid_x, _pos[0]); _x++){
				var _xx = grid_to_pos_x(_x, _pos[1]);
				var _yy = grid_to_pos_y(_x, _pos[1]);
				draw_sprite_ext(spr_conveyor, _dir, _xx, _yy, 1, 1, 0, col, 1);
			}
		}
		else{				// y-direction
			var _len = grid_y - _pos[1]
			var _dir = sign(_len) + 1;
			
			for (var _y=min(grid_y, _pos[1]); _y <= max(grid_y, _pos[1]); _y++){
				var _xx = grid_to_pos_x(_pos[0], _y);
				var _yy = grid_to_pos_y(_pos[0], _y);
				draw_sprite_ext(spr_conveyor, _dir, _xx, _yy, 1, 1, 0, col, 1);
			}
		}
	}
}
else{ // draw preview
	draw_sprite_ext(object_get_sprite(object_buildings[selected_building]), selected_dir, _draw_x, _draw_y, 1, 1, 0, col, 1);
}