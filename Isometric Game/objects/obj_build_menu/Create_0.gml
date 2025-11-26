fp_ui_layer = layer_get_flexpanel_node("ui_build_menu");
fp_scroll_bar_nodes = flexpanel_node_get_child(fp_ui_layer, "scroll_bar_nodes");

num_children = flexpanel_node_get_num_children(fp_scroll_bar_nodes)

scroll_speed = 0;
scroll_acceleration = 4;
scroll_value = 0;

node_width = 50;
gap_width = 4;
row_width = 474;