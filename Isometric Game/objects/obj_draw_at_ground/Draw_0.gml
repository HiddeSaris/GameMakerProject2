repeat (ds_stack_size(draw_stack)) {
	var func = ds_stack_pop(draw_stack);
	func();
}