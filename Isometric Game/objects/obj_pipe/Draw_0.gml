draw_self();

for (var i=0; i<array_length(inv_items); i++){
	//draw_sprite(sprite_items[inv_items[i][0]], 0, x + inv_items[i][1], y + inv_items[i][2]);
	draw_circle(x+inv_items[i][1], y+inv_items[i][2], 1, false);
	//draw_text(x+inv_items[i][1], y+inv_items[i][2], string(inv_items[i][1])+ " " + string(inv_items[i][2]))
}