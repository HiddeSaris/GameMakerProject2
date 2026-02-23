plant_timer++;

if (plant_timer > plant_dur && seeds > 0){
	plant_timer = 0;
	if (plant_tree()){
		seeds--;
	}
}

//move_items();