if (alive){
	if (growth_level < growth_number and random(1) < growth_chance){
		growth_level++; // growing
		image_index = growth_level + 1;
	}
	else if (random(1) < change_color_chance){
		if (image_index = 5){
			image_index = 6;
		}
		else if (image_index = 6){
			image_index = 5;
		}
	}
}
else {
	image_index = 0;
}