/*
var loop_game_state = false;

do {
*/
	if (state == STATE.CHECK_FOR_INPUT) {
		// checking for movement input
		if      (input_up())    y_dir = -1;	
		else if (input_left())  x_dir = -1;
		else if (input_down())  y_dir = 1;	
		else if (input_right()) x_dir = 1;
		
		if (x_dir != 0 || y_dir != 0) {
			//show_debug_message("movement: " + string(x_dir) + ", " + string(y_dir));
			state = STATE.MOVEMENT;
			loop_game_state = true;
		}
		// checking for selection input
		else if (input_select()) {
			state = STATE.SELECTING_ACTION;
		}
		// checking for restart input
		else if (input_restart()) {
			room_restart();
		}
	
	} else if (state == STATE.SELECTING_ACTION) {
		// exit
		if (input_exit()) {
			state = STATE.CHECK_FOR_INPUT;
			gui_actions_selected = 0;
		}
	
		// selecting spell or book
		if      (input_right()) gui_actions_selected = (gui_actions_selected+1) mod GUI_ACTIONS.LENGTH;
		else if (input_left())  gui_actions_selected = (gui_actions_selected != 0) ? gui_actions_selected-1 : GUI_ACTIONS.LENGTH-1;
		
		if (input_select()) {
			switch (gui_actions_selected) {
				case GUI_ACTIONS.BOOK:
					state = STATE.BOOK;
					gui_book_selected = 0;
					break;
				case GUI_ACTIONS.SPELL:
					state = STATE.RECITE;
					letters_recited = array_create(0);
					current_letter = -1;
					break;
			}
			gui_actions_selected = 0;
		}
		
	} else if (state == STATE.BOOK) {
		// exit
		if (input_exit()) {
			state = STATE.CHECK_FOR_INPUT;
		}

		// navigate spellbook gui
		if (input_right()) gui_book_selected = (gui_book_selected+1) mod SPELLS.LENGTH;
		if (input_left())  gui_book_selected = (gui_book_selected != 0) ? (gui_book_selected-1) : SPELLS.LENGTH-1;

		if (input_select()) {
			if (unlocked_spells[gui_book_selected]) {
				spell_to_be_performed = gui_book_selected;
				state = STATE.PERFORM_SPELL;
				loop_game_state = true;
			}
		}
	} else if (state == STATE.RECITE) {
		// exit
		if (input_exit()) {
			state = STATE.CHECK_FOR_INPUT;
		}
		// attempt casting
		if (input_select()) {
			if (current_letter != -1) array_push(letters_recited, current_letter);
		
			var successful_casting = false;
			for (var i = 0; i < SPELLS.LENGTH; i++) {
				if (array_equals(letters_recited, spell_table[i][SPELL_ATTRIBUTE.SEQUENCE])) {
					spell_to_be_performed = i;
					state = STATE.PERFORM_SPELL;
					successful_casting = true;
					break;
				}
			}
			if (!successful_casting) {
				state = STATE.CHECK_FOR_INPUT;
			}
		}
		// undo/redo
		if (input_undo()) {
			if (current_letter != -1) {
				current_letter = -1;
			} else if (array_length(letters_recited) != 0) {
				array_pop(letters_recited);
				current_letter = -1;
				show_debug_message("pop");
			}
		}
		if (input_restart()) {
			letters_recited = array_create(0);
			current_letter = -1;
		}
		
		// write
		var dir = -1;
		if (input_up())    dir = LETTER.U;
		if (input_left())  dir = LETTER.L;
		if (input_down())  dir = LETTER.D;
		if (input_right()) dir = LETTER.R;
		
		if (dir != -1) {
			if      (current_letter == -1) current_letter = dir;
			else if (current_letter == LETTER.U && dir == LETTER.R) current_letter = LETTER.UR;
			else if (current_letter == LETTER.U && dir == LETTER.L) current_letter = LETTER.UL;
			else if (current_letter == LETTER.D && dir == LETTER.R) current_letter = LETTER.DR;
			else if (current_letter == LETTER.D && dir == LETTER.L) current_letter = LETTER.DL;
			else if (current_letter == LETTER.L && dir == LETTER.U) current_letter = LETTER.LU;
			else if (current_letter == LETTER.L && dir == LETTER.D) current_letter = LETTER.LD;
			else if (current_letter == LETTER.R && dir == LETTER.U) current_letter = LETTER.RU;
			else if (current_letter == LETTER.R && dir == LETTER.D) current_letter = LETTER.RD;
			else if (current_letter == LETTER.UR   && dir == LETTER.D) current_letter = LETTER.URD;
			else if (current_letter == LETTER.URD  && dir == LETTER.L) current_letter = LETTER.URDL;
			else if (current_letter == LETTER.URDL && dir == LETTER.U) current_letter = LETTER.URDLU;
			else if (current_letter == LETTER.UL   && dir == LETTER.D) current_letter = LETTER.ULD;
			else if (current_letter == LETTER.ULD  && dir == LETTER.R) current_letter = LETTER.ULDR;
			else if (current_letter == LETTER.ULDR && dir == LETTER.U) current_letter = LETTER.ULDRU;
			else if (current_letter == LETTER.DR   && dir == LETTER.U) current_letter = LETTER.DRU;
			else if (current_letter == LETTER.DRU  && dir == LETTER.L) current_letter = LETTER.DRUL;
			else if (current_letter == LETTER.DRUL && dir == LETTER.D) current_letter = LETTER.DRULD;
			else if (current_letter == LETTER.DL   && dir == LETTER.U) current_letter = LETTER.DLU;
			else if (current_letter == LETTER.DLU  && dir == LETTER.R) current_letter = LETTER.DLUR;
			else if (current_letter == LETTER.DLUR && dir == LETTER.D) current_letter = LETTER.DLURD;
			else if (current_letter == LETTER.LU   && dir == LETTER.R) current_letter = LETTER.LUR;
			else if (current_letter == LETTER.LUR  && dir == LETTER.D) current_letter = LETTER.LURD;
			else if (current_letter == LETTER.LURD && dir == LETTER.L) current_letter = LETTER.LURDL;
			else if (current_letter == LETTER.LD   && dir == LETTER.R) current_letter = LETTER.LDR;
			else if (current_letter == LETTER.LDR  && dir == LETTER.U) current_letter = LETTER.LDRU;
			else if (current_letter == LETTER.LDRU && dir == LETTER.L) current_letter = LETTER.LDRUL;
			else if (current_letter == LETTER.RU   && dir == LETTER.L) current_letter = LETTER.RUL;
			else if (current_letter == LETTER.RUL  && dir == LETTER.D) current_letter = LETTER.RULD;
			else if (current_letter == LETTER.RULD && dir == LETTER.R) current_letter = LETTER.RULDR;
			else if (current_letter == LETTER.RD   && dir == LETTER.L) current_letter = LETTER.RDL;
			else if (current_letter == LETTER.RDL  && dir == LETTER.U) current_letter = LETTER.RDLU;
			else if (current_letter == LETTER.RDLU && dir == LETTER.R) current_letter = LETTER.RDLUR;
			// starting new letter
			else {
				array_push(letters_recited, current_letter);
				current_letter = dir;
			}
		}

	} else if (state == STATE.PERFORM_SPELL) {
		show_debug_message("performing spell!");
		// unlock if new spell
		if (unlocked_spells[spell_to_be_performed] == false) {
			unlocked_spells[spell_to_be_performed] = true;
			number_of_unlocked_spells++;
			var temp_list = ds_list_create();
			for (var i = 0; i < SPELLS.LENGTH; i++) {
				if (unlocked_spells[i] == false) continue;
				ds_list_add(temp_list, i);
			}
			unlocked_spells_list = temp_list;
			ds_list_destroy(temp_list);
		}
		
		switch (spell_to_be_performed) {
			case SPELLS.RETURN:
				if (room != rm_forest_1) {
					money += lent_money;
					lent_money = 0;
					room_goto(rm_forest_1);				
				}
				break;
			case SPELLS.REVEAL:
				// implement spell here
				break;
			case SPELLS.WIND:
				// implement spell here
				break;
		}
		state = STATE.CHECK_FOR_INPUT;
		loop_game_state = true;

	} else if (state == STATE.MOVEMENT) {
		// move until collision
		if (player_collision(x_dir, y_dir, spd) == false) {
			// move
			obj_player.x += x_dir * spd;
			obj_player.y += y_dir * spd;

			// room transition
			var xx_dir = x_dir,    yy_dir = y_dir;
			var xx = obj_player.x, yy = obj_player.y;
			var teleport_success = false;
			var room_transitioner = noone;
			with (obj_player) {
				room_transitioner = instance_place(x, y, obj_room_transitioner)
				if (room_transitioner != noone) {
					if (room_transitioner.destination != noone) {
						if (room_transitioner.dest_x == -1) {
							if      (xx_dir ==  1) xx = 0;
							else if (xx_dir == -1) xx = room_width-1;
						} else {
							xx = room_transitioner.dest_x;
						}
						if (room_transitioner.dest_y == -1) {
							if      (yy_dir ==  1) yy = 0;
							else if (yy_dir == -1) yy = room_height-1;
						} else {
							yy = room_transitioner.dest_y;	
						}
						teleport_success = true;
					}
				}
			}
			if (teleport_success) {
				money += lent_money;
				lent_money = 0;
				room_goto(room_transitioner.destination);
				teleport_x = xx;
				teleport_y = yy;
				alarm[0] = 1;
			}
			
			// key pickup
			var key_pickup_success = false;
			with (obj_player) {
				var key = instance_place(x, y, obj_key);
				if (key != noone) {
					key_pickup_success = true;
					instance_destroy(key);
				}
			}
			if (key_pickup_success) got_a_key = true;
			
			// money pickup
			var money_pickup_amount = 0;
			with (obj_player) {
				var money_object = instance_place(x, y, obj_money);
				if (money_object != noone) {
					money_pickup_amount = 50;
					instance_destroy(money_object);
				}
			}
			lent_money += money_pickup_amount;
			
			// spike death
			var death = false;
			with (obj_player) {
				var spike = instance_place(x, y, obj_spike);
				if (spike != noone) {
					death = true;			
				}
			}
			if (death) {
				room_persistent = false;
				lent_money = 0;
				room_restart();
				alarm[1] = 1;
			}
			
		} else {
			state = STATE.CHECK_FOR_INPUT;
			x_dir = 0;
			y_dir = 0;
		}

	} else if (state == STATE.RESPONSE) {
		state = STATE.CHECK_FOR_INPUT;
	}

/*
} until (loop_game_state == false);

