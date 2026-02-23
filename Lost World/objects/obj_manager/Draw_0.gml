var surface_w = (hcells + vcells) * iso_width/2;
var surface_h = (hcells + vcells+2) * iso_height/2;

if (update_surface or !surface_exists(surface_tiles)){
	update_draw_surface()
	update_surface = false;
}
draw_surface(surface_tiles, -surface_w/2, 0);

