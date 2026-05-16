function input_up() {
	return (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up));
}
function input_down() {
	return (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down));
}
function input_left() {
	return (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left));
}
function input_right() {
	return (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right));
}
function input_select() {
	return (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter));
}
function input_exit() {
	return (keyboard_check_pressed(vk_escape));
}

function input_restart() {
	return (keyboard_check_pressed(ord("R")));
}
function input_undo() {
	return (keyboard_check_pressed(ord("Z")));	
}