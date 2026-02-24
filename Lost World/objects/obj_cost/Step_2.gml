var height = 147;

flexpanel_node_style_set_position(fp_cost_panel, flexpanel_edge.left, device_mouse_x_to_gui(0), flexpanel_unit.point);
flexpanel_node_style_set_position(fp_cost_panel, flexpanel_edge.top, device_mouse_y_to_gui(0) - height, flexpanel_unit.point);
flexpanel_calculate_layout(fp_cost_layer, display_get_gui_width(), display_get_gui_height(), flexpanel_direction.LTR);

// if hovering over building button set cost panel visible and place it at mouse position
// and update prices according to specific building
if (global.hovering) {
	global.hovering = false;
	layer_set_visible("CostLayer", true);
	
	var text_wood = layer_text_get_id("CostLayer", "text_546B5C3F")
	layer_text_text(text_wood, string(obj_manager.building_costs[global.hovering_building][items.wood])) //Amount of wood
	
	var text_steel = layer_text_get_id("CostLayer", "text_1C5ADA9C")
	layer_text_text(text_steel, string(obj_manager.building_costs[global.hovering_building][items.iron])) //Amount of steel
}
else {
	layer_set_visible("CostLayer", false);
}