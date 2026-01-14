draw_self();

for (var i=0; i<array_length(inv_items); i++){
	draw_sprite(obj_manager.sprite_items[inv_items[i][0]], 0, x + inv_items[i][1], y + inv_items[i][2]);
	draw_circle(x+inv_items[i][1], y+inv_items[i][2], 1, false);
}

for (var i=0; i<array_length(dir_coords); i++){
	draw_circle(x+dir_coords[i][0], y+dir_coords[i][1], 0.5, false);
}