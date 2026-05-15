
// foundation
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(0, (room_height-1 - SIZES.GUI_HEIGHT), room_width-1, room_height-1, false);
// icons
if (state == STATE.CHECK_FOR_INPUT || state == STATE.SELECTING_ACTION || state == STATE.MOVEMENT || state = STATE.RESPONSE) {
	var icon_color = c_dkgray;
	for (var i = 0; i < GUI_ACTIONS.LENGTH; i++) {
		if (state == STATE.SELECTING_ACTION) {
			if (i == gui_actions_selected) {
				icon_color = c_ltgray;
			} else {
				icon_color = c_gray;
			}
		} else {
			icon_color = c_dkgray;
		}
		draw_sprite_ext(
			spr_action_icons,
			i,
			(room_width)/2 - (SIZES.ACTION_DIST_FROM_CENTER * GUI_ACTIONS.LENGTH/2) + (SIZES.ACTION_DIST_FROM_CENTER*2)*i - 1,
			room_height-1 - SIZES.GUI_HEIGHT/2,
			1,
			1,
			0,
			icon_color,
			1
		); 
	}
} else if (state == STATE.RECITE) {
	var padding = 1;
	var letter_w = 5;
	
	var xx = padding;
	var yy = room_height-1 - SIZES.GUI_HEIGHT/2;
	for (var i = 0; i < array_length(letters_recited); i++) {
		draw_sprite(spr_letters, letters_recited[i], xx, yy);
		xx += padding + letter_w;
	}
	if (current_letter != -1) {
		draw_sprite(spr_letters, current_letter, xx, yy);
		xx += padding + letter_w;
	}
} else if (state == STATE.BOOK) {
	var padding = 3;
	var spell_w = 11;

	var spell_color = c_gray;
	var xx = 1;
	var yy = room_height-1 - SIZES.GUI_HEIGHT/2;
	for (var i = 0; i < SPELLS.LENGTH; i++) {
		if (gui_book_selected == i) {
			spell_color = c_ltgray;
		} else {
			spell_color = c_gray;
		}
		if (unlocked_spells[i]) {
			draw_sprite_ext(spr_spell_icons, i, xx, yy, 1, 1, 0, spell_color, 1);
		} else {
			draw_sprite_ext(spr_spell_icon_empty, 0, xx, yy, 1, 1, 0, spell_color, 1);
		}
		xx += padding + spell_w;
	}
}

											
draw_set_color(c_white);