if start
{
	audio_play_sound(songs[current_song], 1, false)
	start = 0
}
if audio_is_playing(songs[current_song]) == false
{
	current_song += 1
	if audio_sound_get_track_position(songs[current_song]) != 0
	{
		audio_sound_set_track_position(songs[current_song], 0);
	}
	audio_play_sound(songs[current_song], 1, false)
}
if keyboard_check_pressed(77)
{
	audio_pause_sound(songs[current_song])
	if current_song == 2 {current_song = 0}
	else {current_song += 1}
	audio_play_sound(songs[current_song], 1, false)
}
if keyboard_check_pressed(78)
{
	audio_pause_sound(songs[current_song])
	if current_song == 1 {current_song = 2}
	else {current_song -= 1}
	audio_play_sound(songs[current_song], 1, false)
}
