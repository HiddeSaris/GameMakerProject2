draw_self();

var begin_x = clamp(grid_x - chop_radius, 0, hcells);
var begin_y = clamp(grid_y - chop_radius, 0, vcells);
var end_x = clamp(grid_x + chop_radius, 0, hcells);
var end_y = clamp(grid_y + chop_radius, 0, vcells);

draw_sprite(spr_indicator, 0, grid_to_pos_x(begin_x, begin_y), grid_to_pos_y(begin_x, begin_y));
draw_sprite(spr_indicator, 0, grid_to_pos_x(begin_x, end_y), grid_to_pos_y(begin_x, end_y));
draw_sprite(spr_indicator, 0, grid_to_pos_x(end_x, begin_y), grid_to_pos_y(end_x, begin_y));
draw_sprite(spr_indicator, 0, grid_to_pos_x(end_x, end_y), grid_to_pos_y(end_x, end_y));

for (var i=0; i<array_length(inv_items); i++){
	draw_sprite(sprite_items[inv_items[i][0]], 0, x + inv_items[i][1], y + inv_items[i][2]);
	draw_circle(x+inv_items[i][1], y+inv_items[i][2], 1, false);
}

for (var i=0; i<array_length(dir_coords); i++){
	draw_circle(x+dir_coords[i][0], y+dir_coords[i][1], 0.5, false);
}