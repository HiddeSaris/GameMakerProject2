grid_x = pos_to_grid_x(mouse_x, mouse_y);
grid_y = pos_to_grid_y(mouse_x, mouse_y);

x = lerp(x, grid_to_pos_x(grid_x, grid_y), 0.3);
y = lerp(y, grid_to_pos_y(grid_x, grid_y), 0.3);

depth = -y - 5