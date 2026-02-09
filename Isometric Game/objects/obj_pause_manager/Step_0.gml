if keyboard_check_pressed(vk_escape) and !layer_get_visible("Main_menuLayer") { escape_pressed = true }

if (escape_pressed or global.resume_button_pressed)
{
	hide_build_menu();
	obj_manager.building_state = building_states.selecting;
	tablet_on = !tablet_on
	global.resume_button_pressed = false
	escape_pressed = false
}

if tablet_on
{
	var dist = point_distance(xNow, yNow, xTo, yTo);
	if (dist <= 1)
	{
		if (frames_on = 1 or frames_on = 15)
		{
			current_sprite = 1
		}
		else
		{
			current_sprite = 0
		}
		xNow = xTo;
		yNow = yTo;
		if !paused {open_escape = true} 
		if open_escape and frames_on >= 45
		{
			draw_screen = false
			paused = !paused
			update_pause()
			open_escape = false
		}
		frames_on += 1
	}
	else 
	{
		xNow = lerp(xNow, xTo, move_speed);
		yNow = lerp(yNow, yTo, move_speed);
		draw_screen = true
		current_sprite = 0
	}
}
else
{
	frames_on = 0
	if paused
	{
		paused = !paused
		update_pause()
	}
	var dist = point_distance(xNow, yNow, xStart, yStart);
	if (dist <= 1)
	{
		xNow = xStart;
		yNow = yStart;
		draw_screen = false
	}
	else 
	{
		xNow = lerp(xNow, xStart, move_speed);
		yNow = lerp(yNow, yStart, move_speed);
		draw_screen = true
	}
}