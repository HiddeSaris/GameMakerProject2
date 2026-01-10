//inv_items = array_create(items.COUNT, 0);




function can_add_item(_input_dir){
	return true;
}

function add_item(item, _input_dir){
	obj_manager.inv_items[item[0]]++;
}