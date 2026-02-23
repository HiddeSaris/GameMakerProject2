repeat (ds_queue_size(draw_queue)) {
	var func = ds_queue_dequeue(draw_queue);
	func();
}