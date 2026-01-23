output_dir = real(_dir);

num_gardens = 0;

image_speed = 0;
image_index = output_dir;

function add_garden(_x, _y) {
	num_gardens++;
}

function remove_garden(_x, _y) {
	num_gardens--;
}

function get_data() {
	return {
		output_dir : output_dir,
	}
}