switch (destroybutton_id)
{
case 0:
	if (obj_manager.building_state != building_states.destroying){
		obj_manager.building_state = building_states.destroying;
	}
	else {
		obj_manager.building_state = building_states.selecting
	}
break;
}