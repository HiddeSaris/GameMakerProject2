function hide_flexpanel(node_id) {
    // hide the flexpanel
    flexpanel_node_style_set_display(node_id, flexpanel_display.none);
    // hide all layerElements within that flexpanel
    var fpStruct = flexpanel_node_get_struct(node_id);
    for (var i = 0; i < array_length(fpStruct.layerElements); i++) {
        var fpStructElem = fpStruct.layerElements[i]
		if fpStructElem.type == "Text"{
			layer_text_alpha(fpStructElem.elementId, 0);
		}
		else{
			fpStructElem.flexVisible = false;
		}
    }
}

function show_flexpanel(node_id) {
    // show the flexpanel
    flexpanel_node_style_set_display(node_id, flexpanel_display.flex);
    // show all layerElements within that flexpanel
    var fpStruct = flexpanel_node_get_struct(node_id);
    for (var i = 0; i < array_length(fpStruct.layerElements); i++) {
        var fpStructElem = fpStruct.layerElements[i]
		if fpStructElem.type == "Text"{
			layer_text_alpha(fpStructElem.elementId, 1);
		}
		else{
			fpStructElem.flexVisible = true;
		}
    }
}

function hide_build_menu() {
	var ui_flexpanels = layer_get_flexpanel_node("ui_build_menu")
	var flexpanel = flexpanel_node_get_child(ui_flexpanels, "build_menu");
	hide_flexpanel(flexpanel);
}

function show_build_menu() {
	var ui_flexpanels = layer_get_flexpanel_node("ui_build_menu")
	var flexpanel = flexpanel_node_get_child(ui_flexpanels, "build_menu");
	show_flexpanel(flexpanel);
}

// bron: https://gamemaker.io/en/blog/coding-gui-elements-using-structs
function GUIElementController() constructor {

    // make this struct a global variable so all elements can reference easily
    global.__ElementController = self;

    // list of all GUI elements
    elements = ds_list_create();

    // the GUI element struct in focus currently
    element_in_focus = undefined;    

    // prevents click-throughs on overlapping elements
    can_click = true;   
	
	can_scroll = true;

    /// @function   step()
    static step = function() {
        if (mouse_check_button_pressed(mb_left)) {
			element_in_focus = undefined;
		}
		can_click = true;

        // call `step` function in all elements
        var count = ds_list_size(elements);
        for(var i = 0; i < count; i++) elements[| i].step();
    }

    /// @function   draw()
    static draw = function() {

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);

        // call `draw` function on all elements in reverse-creation order
        for(var i = ds_list_size(elements)-1; i>=0; i--)
            elements[| i].draw();
    }

    /// @function   destroy()
    static destroy = function() {

        // free all elements from memory
        for(var i = ds_list_size(elements)-1; i>=0; i--)
            elements[| i].destroy();
        ds_list_destroy(elements);

        // remove global reference
        delete global.__ElementController;
        global.__ElementController = undefined;

    }

}

function GUIElement() constructor {

    value = undefined; // int, string, or bool based on type
    name  = undefined; // unique name
	
	bg_col = c_gray;
	col    = c_white;
	
	outline_width = 1;

    // dimensions
    static width   = 200;
    static height  = 32;
    static padding = 16;

    // a reference to the controller
    controller = global.__ElementController;

    // add to controller's list of elements
    ds_list_add(controller.elements, self); 

    /// @function   has_focus()
    static has_focus = function() {
        return controller.element_in_focus == self;
    }

    /// @function   set_focus()
    static set_focus = function() {
        controller.element_in_focus = self; 
    }

    /// @function   remove_focus()
    static remove_focus = function() {
        controller.element_in_focus = undefined;
    }

    // value setter and getter
    static get = function() { return value; }
    static set = function(_value) { value = _value; }


	static click_left = function() { }
	static hold_left = function() { }
	static rel_left = function() { }
	static scroll = function(_dir) { }
    static listen = function() { }
	
	/// @function   step()
    static step = function() 
	{
        // check for mouse click inside bounding box AND ensure no click already happened this gamestep
        if (controller.can_click && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), pos_x, pos_y, pos_x + width, pos_y + height)) {

            // tell controller we clicked on an input this step
            controller.can_click = false;

			if (mouse_check_button_pressed(mb_left)){
				click_left();
			}
			if (mouse_check_button(mb_left)){
				hold_left();
			}
			if (mouse_check_button_released(mb_left)){
				rel_left();
			}

        }
		
		mouse_up = mouse_wheel_up();
		mouse_down = mouse_wheel_down();
		if ((mouse_up || mouse_down) && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), pos_x, pos_y, pos_x + width, pos_y + height)){
			controller.can_scroll = false;
			
			scroll(mouse_down - mouse_up);
		}

        // if the element has focus, listen for input
        if (has_focus()) {listen();}
    }
    

    // drawing
    static draw = function() { }
	
	/// @function draw_rectangle_ext(_x, _y, _xx, _yy, _filled, _outline_size = 1, _fill_color = c_white, _outline_color = _fill_color)
	static draw_rectangle_ext = function(_x, _y, _xx, _yy, _filled, _outline_size = 1, _fill_color = c_white, _outline_color = _fill_color) {
		corners = [[min(_x, _xx)-1+_outline_size/2, min(_y, _yy)-1+_outline_size/2], [min(_x, _xx)-1+_outline_size/2, max(_y, _yy)-_outline_size/2], [max(_x, _xx)-_outline_size/2, max(_y, _yy)-_outline_size/2], [max(_x, _xx)-_outline_size/2, min(_y, _yy)-1+_outline_size/2]];
		if (_filled && _fill_color == _outline_color){
			draw_rectangle(_x, _y, _xx, _yy, false);
		}
		else{
			draw_set_color(_outline_color);
			draw_line_width(corners[0][0], corners[0][1]-outline_width/2, corners[1][0], corners[1][1]+outline_width/2, _outline_size);
			draw_line_width(corners[1][0]-outline_width/2, corners[1][1], corners[2][0]+outline_width/2, corners[2][1], _outline_size);
			draw_line_width(corners[2][0], corners[2][1]+outline_width/2, corners[3][0], corners[3][1]-outline_width/2, _outline_size);
			draw_line_width(corners[3][0]+outline_width/2, corners[3][1], corners[0][0]-outline_width/2, corners[0][1], _outline_size);
			
			if (_filled){
				draw_set_color(_fill_color);
				draw_rectangle(min(_x, _xx)+_outline_size, min(_y, _yy)+_outline_size, max(_x, _xx)-_outline_size, max(_y, _yy)-_outline_size, false);
			}
			draw_set_color(c_white);
		}
	}

    /// @function   destroy()
    static destroy = function() {
        // remove from controller's list of elements
        ds_list_delete(controller.elements, ds_list_find_index(controller.elements, self));
    }
}

///// @function   Checkbox(string:name, real:pos_x, real:pos_y, bool:checked)
function Checkbox(_name, _x, _y, _height = 32, _width = 32, _outline_width = 4, _checked = false, _bg_col = c_grey, _fill_col = c_white) : GUIElement() constructor {

    // passed-in vars
    pos_x    = _x;
    pos_y    = _y;
	height = _height;
	width  = _width;
	outline_width = _outline_width;
    name   = _name;
	bg_col = _bg_col;
	col    = _fill_col;

    static click_left = function() {
        set(!get());    
        show_debug_message("You " + (get() ? "checked" : "unchecked") + " the Checkbox named `" + string(name) + "`!"); 
    }

    /// @function   draw()
    static draw = function() {
        draw_rectangle_ext(pos_x, pos_y, pos_x + height, pos_y + width, !get(), outline_width, col, bg_col); // box
        draw_text(pos_x + height + padding, pos_y + (height * 0.5), name); // name  
    }

    // set value
    set(_checked);

}
	
/// @function   Textfield(_name, _x, _y, _value, _bg = true, _filled = true, _outline_size = 2, _changeable = false, _text_col = c_black, _bg_col = c_white, _outline_col = c_grey, _unfocused_alpha = 0.8)
function Textfield(_name, _x, _y, _value, _bg = true, _filled = true, _outline_size = 2, _changeable = false, _text_col = c_black, _bg_col = c_white, _outline_col = c_grey, _unfocused_alpha = 0.9) : GUIElement() constructor {

    // passed-in vars
    name         = _name;
    pos_x            = _x;
    pos_y            = _y;
	bg           = _bg;
	filled       = _filled;
	outline_size = _outline_size;
	changeable   = _changeable;
	col          = _text_col;
	bg_col       = _bg_col;
	outline_col  = _outline_col;
	unfocused_alpha = _unfocused_alpha;
	blinker_char = "|"
	blinker_interval = 30; // frames
	blinker_time = 0;
	blinker = false;

	padding = 8;
	
    static set = function(str) {

        // value hasn't changed; quit
        if (value == str) return;

        value = str;

        show_debug_message("You set the Textfield named `" + string(name) + "` to the value `" + string(value) + "`");  

    }

    static click_left = function() {
		if (changeable){
	        set_focus();
	        keyboard_string = get();    
		}
		else{
			//controller.can_click = true;
		}
    }

    /// @function   listen()
    static listen = function() {
        if (string_width(keyboard_string) > width - padding*2){
			var len = string_length(keyboard_string);
			keyboard_string = string_copy(keyboard_string, 1, len-1); // removes last char
		}
		
		set(keyboard_string);  
		
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) remove_focus();
    }

    /// @function   draw()
    static draw = function() {
		blinker_time++;
		if (blinker_time > blinker_interval){
			blinker = !blinker
			blinker_time = 0;
		}
        draw_set_alpha(has_focus() ? 1 : unfocused_alpha);

        // background
		if(bg){
	        draw_rectangle_ext(pos_x, pos_y, pos_x + width, pos_y + height, filled, outline_size, bg_col, outline_col);
		}

		// draw input text
		draw_set_color(col)
		var _text = get();
		if (blinker && has_focus()){_text += blinker_char}
		draw_text(pos_x + padding, pos_y + (height * 0.5), _text);
		
		draw_set_alpha(1);
		draw_set_color(c_white);
    }


    // set value
    set(_value);
}

function Button(_func, _x, _y, _w, _h, _text = "", _outline_w = 1, _fill_col = c_white, _active_fill_col = c_ltgrey, _outline_col = c_ltgrey, _active_outline_col = c_grey, _text_col = c_black) : GUIElement() constructor{
	
	func = _func
	pos_x = _x
	pos_y = _y
	width = _w
	height = _h
	text = _text
	outline_w = _outline_w
	fill_col = _fill_col
	outline_col = _outline_col
	text_col = _text_col
	
	static click_left = function(){
		func()
	}
	
	static hold_left = function(){
		fill_col = _active_fill_col
		outline_col = _active_outline_col
	}
	
	static draw = function(){
		draw_rectangle_ext(pos_x, pos_y, pos_x + width, pos_y + height, true, outline_w, fill_col, outline_col)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_text(pos_x + width/2, pos_y + height/2, text)
	}
}