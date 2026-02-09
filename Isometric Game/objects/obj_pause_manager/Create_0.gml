layer_set_visible("Main_menuLayer", true)
global.main_menu = true;

//PAUSING ANIMATION

paused = false
layer_name = "PauseLayer"

update_pause = function()
{
	if (paused)
	{
		layer_set_visible(layer_name, true)
	}
	else 
	{
		layer_set_visible(layer_name, false)
		layer_set_visible("SettingsLayer", false)
	}
}
update_pause()

layer_set_visible("SettingsLayer", false)

//X and Y positioning of hud
xStart = 734
yStart = window_get_height() + 365
xTo = 734
yTo = 240
xNow = xStart
yNow = yStart

move_speed = 0.1
//Extra variables
global.resume_button_pressed = false
open_escape = false
draw_screen = false
tablet_on = false

current_sprite = 0
frames_on = 0

escape_pressed = false