


function set_resolution_by_zoom(zoom) {
	var width = room_width;
	var height = room_height;
	window_set_size(width*zoom, height*zoom);
	//application_surface_draw_enable(false);
	surface_resize(application_surface, width*zoom, height*zoom);
	display_set_gui_size(width*zoom, height*zoom);
	window_set_position(display_get_width()/2  - window_get_width()/2, display_get_height()/2 - window_get_height()/2);
}