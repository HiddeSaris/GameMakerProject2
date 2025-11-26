output_dir = real(output_dir);
input_dir = array_filter([dir.up, dir.right, dir.down, dir.left], function(val, ind){return val != output_dir});

image_speed = 0;
image_index = output_dir;


dist_items = 5;
conveyor_speed = 0.03;

inv_items = [];

dir_coords = [global.up, global.right, global.down, global.left];
