if (not done) {
	update_timer++;
}

if (update_timer >= update_dur) {
	update_timer = 0;
	update_flood();
	if (array_length(tiles) == 0) {
		done = true;
	}
}