output_dir = _dir;
image_speed = 0;

if (alive && image_index == 0){
	image_index = 1;
}

growth_chance = 0.001;
growth_number = 4;

change_color_chance = 0.0001;

grid_x = pos_to_grid_x(x, y);
grid_y = pos_to_grid_y(x, y);

function get_data(){
	return {
		image_index: image_index,
		growth_level: growth_level,
		alive: alive,
	};
}

function is_grown(){
	return image_index >= 5;
}

function is_dead(){
	return image_index == 0;
}

function is_choppable(){
	return is_grown() or is_dead();
}