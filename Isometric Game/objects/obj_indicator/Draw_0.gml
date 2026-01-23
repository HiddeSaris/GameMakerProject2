draw_self();

var col;
if (m.can_build_now){
	col = c_lime;
}
else {
	col = c_red;
}

if (mouse_check_button(mb_left)){
	if (m.building_state == building_states.building && m.building_conveyors){
		var _pos = m.building_conveyor_pos
		
		m.building_conveyors_dir = (abs(grid_x - _pos[0]) >= abs(grid_y - _pos[1]));
		
		if (grid_x == _pos[0] && grid_y == _pos[1]){
			draw_sprite_ext(spr_conveyor, m.selected_dir, x, y, 1, 1, 0, col, 1);
		}
		else if (m.building_conveyors_dir){ // x-direction
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
else if (m.building_state == building_states.building){ // draw preview
	switch(m.selected_building){
	case buildings.lumberjack:
		draw_area(lumberjack_get_area(grid_x, grid_y, 5, m.selected_dir), spr_indicator, c_white);
	break;
	case buildings.farm:
		draw_circle_area(farm_get_area(grid_x, grid_y, m.farm_radius), spr_indicator, c_white);
	}
	draw_sprite_ext(sprite_buildings[m.selected_building], m.selected_dir, x, y, 1, 1, 0, col, 1);
	
}
