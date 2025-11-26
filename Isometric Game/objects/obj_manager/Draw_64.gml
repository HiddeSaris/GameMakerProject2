draw_set_font(fnt_iFlash)
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(0, 0, string(fps) + "fps, " + string(instance_count) + " instances");
draw_text(0, 20, "gui_x: " + string(display_get_gui_width()));
draw_text(0, 40, "gui_y: " + string(display_get_gui_height()));
draw_text(0, 60, "click: " + string(global.can_click));


global.can_scroll = true;
global.can_click = true;