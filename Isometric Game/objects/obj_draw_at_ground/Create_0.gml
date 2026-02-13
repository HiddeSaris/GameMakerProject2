depth = 0; // draws things like areas below trees and buildings

draw_stack = ds_stack_create();

//add a function to be excecuted at depth = 0
function add_func(func) {
	ds_stack_push(draw_stack, func);
}
