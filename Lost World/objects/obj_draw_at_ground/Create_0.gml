depth = 0; // draws things like areas below trees and buildings

draw_queue = ds_queue_create();

//add a function to be excecuted at depth = 0
function add_func(func) {
	ds_queue_enqueue(draw_queue, func);
}
