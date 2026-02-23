enabled = !enabled
image_alpha = 0.4 + enabled * 0.6

switch (checkbox_id)
{
	case 0: // dark mode
	
	break;
	
	case 1: // debug mode
		obj_manager.toggle_debug = true;
	break;
}