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
			var snd = audio_play_sound(snd_move, 1, false);
			if      (x_dir ==  1) latest_dir = LETTER.R;
			else if (x_dir == -1) latest_dir = LETTER.L;
			else if (y_dir == -1) latest_dir = LETTER.U;
			else if (y_dir ==  1) latest_dir = LETTER.D;
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
		if (input_right()) {
			gui_actions_selected = (gui_actions_selected+1) mod GUI_ACTIONS.LENGTH;
			if (gui_actions_selected == GUI_ACTIONS.INTERACT && !npc_is_adjacent) {
				gui_actions_selected = (gui_actions_selected+1) mod GUI_ACTIONS.LENGTH;
			}
		}
		else if (input_left()) {
			gui_actions_selected = (gui_actions_selected != 0) ? gui_actions_selected-1 : GUI_ACTIONS.LENGTH-1;
			if (gui_actions_selected == GUI_ACTIONS.INTERACT && !npc_is_adjacent) {
				gui_actions_selected = (gui_actions_selected != 0) ? gui_actions_selected-1 : GUI_ACTIONS.LENGTH-1;
			}
		}
		
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
				case GUI_ACTIONS.INTERACT:
					state = STATE.INTERACT;
					gui_shop_selected = 0;
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
		var pitch = 1;
		if (input_up()) {
			dir = LETTER.U;
			pitch = 1.4;
		}
		if (input_left()) {
			dir = LETTER.L;
			pitch = 1.2;
		}
		if (input_down()) {
			dir = LETTER.D;
			pitch = 0.8;
		}
		if (input_right()) {
			dir = LETTER.R;
			pitch = 0.6;
		}
		
		if (dir != -1) {

			if      (current_letter == -1) current_letter = dir;
			else if (current_letter == LETTER.U && dir == LETTER.R)    {current_letter = LETTER.UR;}
			else if (current_letter == LETTER.U && dir == LETTER.L)    {current_letter = LETTER.UL;}
			else if (current_letter == LETTER.D && dir == LETTER.R)    {current_letter = LETTER.DR;}
			else if (current_letter == LETTER.D && dir == LETTER.L)    {current_letter = LETTER.DL;}
			else if (current_letter == LETTER.L && dir == LETTER.U)    {current_letter = LETTER.LU;}
			else if (current_letter == LETTER.L && dir == LETTER.D)    {current_letter = LETTER.LD;}
			else if (current_letter == LETTER.R && dir == LETTER.U)    {current_letter = LETTER.RU;}
			else if (current_letter == LETTER.R && dir == LETTER.D)    {current_letter = LETTER.RD;}
			else if (current_letter == LETTER.UR   && dir == LETTER.D) {current_letter = LETTER.URD;}
			else if (current_letter == LETTER.URD  && dir == LETTER.L) {current_letter = LETTER.URDL;}
			else if (current_letter == LETTER.URDL && dir == LETTER.U) {current_letter = LETTER.URDLU; pitch = 1}
			else if (current_letter == LETTER.UL   && dir == LETTER.D) {current_letter = LETTER.ULD;}
			else if (current_letter == LETTER.ULD  && dir == LETTER.R) {current_letter = LETTER.ULDR;}
			else if (current_letter == LETTER.ULDR && dir == LETTER.U) {current_letter = LETTER.ULDRU; pitch = 1.6}
			else if (current_letter == LETTER.DR   && dir == LETTER.U) {current_letter = LETTER.DRU;}
			else if (current_letter == LETTER.DRU  && dir == LETTER.L) {current_letter = LETTER.DRUL;}
			else if (current_letter == LETTER.DRUL && dir == LETTER.D) {current_letter = LETTER.DRULD; pitch = 0.4}
			else if (current_letter == LETTER.DL   && dir == LETTER.U) {current_letter = LETTER.DLU;}
			else if (current_letter == LETTER.DLU  && dir == LETTER.R) {current_letter = LETTER.DLUR;}
			else if (current_letter == LETTER.DLUR && dir == LETTER.D) {current_letter = LETTER.DLURD; pitch = 1.333}
			else if (current_letter == LETTER.LU   && dir == LETTER.R) {current_letter = LETTER.LUR;}
			else if (current_letter == LETTER.LUR  && dir == LETTER.D) {current_letter = LETTER.LURD;}
			else if (current_letter == LETTER.LURD && dir == LETTER.L) {current_letter = LETTER.LURDL; pitch = 1}
			else if (current_letter == LETTER.LD   && dir == LETTER.R) {current_letter = LETTER.LDR;}
			else if (current_letter == LETTER.LDR  && dir == LETTER.U) {current_letter = LETTER.LDRU;}
			else if (current_letter == LETTER.LDRU && dir == LETTER.L) {current_letter = LETTER.LDRUL; pitch = 1.6}
			else if (current_letter == LETTER.RU   && dir == LETTER.L) {current_letter = LETTER.RUL;}
			else if (current_letter == LETTER.RUL  && dir == LETTER.D) {current_letter = LETTER.RULD;}
			else if (current_letter == LETTER.RULD && dir == LETTER.R) {current_letter = LETTER.RULDR; pitch = 0.4}
			else if (current_letter == LETTER.RD   && dir == LETTER.L) {current_letter = LETTER.RDL;}
			else if (current_letter == LETTER.RDL  && dir == LETTER.U) {current_letter = LETTER.RDLU;}
			else if (current_letter == LETTER.RDLU && dir == LETTER.R) {current_letter = LETTER.RDLUR; pitch = 1.333}
			// starting new letter
			else {
				array_push(letters_recited, current_letter);
				current_letter = dir;
			}
			
			var snd_vocal = audio_play_sound(snd_tone, 1, false);
			audio_sound_pitch(snd_vocal, pitch);

		}

	} else if (state == STATE.PERFORM_SPELL) {
		// unlock if new spell
		if (unlocked_spells[spell_to_be_performed] == false) {			
			unlock_spell(spell_to_be_performed);
		}
		
		var switch_to_response = false;
		switch (spell_to_be_performed) {
			case SPELLS.RETURN:
				var snd_return = audio_play_sound(snd_spell_return, 1, false);
				audio_sound_pitch(snd_return, 1);
				if (room != rm_forest_1) {
					room_teleport(rm_forest_1, false);				
				}
				break;
			case SPELLS.REVEAL:
				// implement spell here
				var snd_reveal = audio_play_sound(snd_spell_reveal, 1, false);
				audio_sound_pitch(snd_reveal, 1);
				break;
			case SPELLS.WIND:
				var snd_wind = audio_play_sound(snd_spell_wind, 1, false);
				audio_sound_pitch(snd_wind, 1.5);
				var check_x = 0;
				var check_y = 0;
				switch (latest_dir) {
					case LETTER.R:
						check_x = 1;
						break;
					case LETTER.L:
						check_x = -1;
						break;
					case LETTER.U:
						check_y = -1;
						break;
					case LETTER.D:
						check_y = 1;
						break;						
				}
				with (obj_player) {
					if (place_meeting(
						x + check_x,
						y + check_y,
						obj_parent_wall
					)) {
						// wall, push self
						x -= check_x*6;
						y -= check_y*6;
						switch_to_response = true;
					} else {
						var pushable = instance_place(
							x + check_x*6, 
							y + check_y*6,
							obj_parent_pushable
						);
						if (pushable != noone) {
							// check for wall or object next to pushable
							// if there is, push self instead? or no ._.
							with (pushable) {
								if (place_meeting(
									x + check_x,
									y + check_y,
									obj_parent_wall
								)) {
									// nothing 
								} else if (place_meeting(
									x + check_x*6,
									y + check_y*6,
									obj_parent_pushable
								)) {
									// nothing 
								} else {
									x += check_x*6;
									y += check_y*6;
									switch_to_response = true;
								}
							}
						}
					}
				}				
				break;
			case SPELLS.INVERT:
				var snd_invert = audio_play_sound(snd_spell_invert, 1, false);
				audio_sound_pitch(snd_invert, 1);
				var check_x = 0;
				var check_y = 0;
				switch (latest_dir) {
					case LETTER.R:
						check_x = 1;
						break;
					case LETTER.L:
						check_x = -1;
						break;
					case LETTER.U:
						check_y = -1;
						break;
					case LETTER.D:
						check_y = 1;
						break;
				}
				with (obj_player) {
					var piece = instance_place(
						x + check_x*6,
						y + check_y*6,
						obj_parent_chess_piece,
					);
					if (piece != noone) {
						piece.allied = !piece.allied;
						switch_to_response = true;
					}
				}
				break;
		}
		if (switch_to_response) {
			state = STATE.RESPONSE;
		} else {
			state = STATE.CHECK_FOR_INPUT;
		}
		loop_game_state = true;

	} else if (state == STATE.MOVEMENT) {
		// move until collision
		if (player_collision(x_dir, y_dir, spd)) {
			state = STATE.RESPONSE;
			x_dir = 0;
			y_dir = 0;
		} else {
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
				npc_is_adjacent = false;
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
			if (key_pickup_success) {
				got_a_key = true;
				var snd_got_key = audio_play_sound(snd_key, 1, false);
			}
			
			// money pickup
			var money_pickup_amount = 0;
			with (obj_player) {
				var money_object = instance_place(x, y, obj_money);
				if (money_object != noone) {
					var snd = audio_play_sound(snd_coin, 1, false);
					audio_sound_pitch(snd, random_range(0.85, 1.15));
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
				var snd_death = audio_play_sound(snd_move, 1, false);
				audio_sound_pitch(snd_death, 0.4);
				room_teleport(room, true);
			}
			// npc is adjacent
			var adjacent = false;
			if (instance_exists(obj_merchant)) {
				with (obj_player) {
					if (distance_to_object(obj_merchant) <= 1) {
						adjacent = true;
					}
				}
			}
			if (adjacent) {
				npc_is_adjacent = true;	
			} else {
				npc_is_adjacent = false;
			}
		}

	} else if (state == STATE.INTERACT) {
		// exit
		if (input_exit()) {
			state = STATE.CHECK_FOR_INPUT;	
		}
		
		// navigate
		if (input_right()) {
			gui_shop_selected = (gui_shop_selected+1) mod SHOP_ITEMS.LENGTH;	
		} else if (input_left()) {
			gui_shop_selected = (gui_shop_selected != 0) ? gui_shop_selected-1 : SHOP_ITEMS.LENGTH-1;
		}
		
		// select
		if (input_select()) {
			for (var i = 0; i < SHOP_ITEMS.LENGTH; i++) {
				var spell = SPELLS.WIND;
				if (gui_shop_selected == 0) spell = SPELLS.WIND;
				if (gui_shop_selected == 1) spell = SPELLS.INVERT;
				if (!shop_brought[gui_shop_selected] && money >= spell_table[spell, SPELL_ATTRIBUTE.PRICE]) {
					money -= spell_table[spell, SPELL_ATTRIBUTE.PRICE];
					shop_brought[gui_shop_selected] = true;
					// REFACTOR, USED ELSEWHERE
					if (unlocked_spells[spell] == false) {
						unlock_spell(spell);
					}
				}
			}
		}
	
	} else if (state == STATE.RESPONSE) {
		state = STATE.CHECK_FOR_INPUT;
		for (var i = 0; i < instance_number(obj_parent_chess_piece); i++) {
			var piece = instance_find(obj_parent_chess_piece, i);
			switch (object_get_name(piece.object_index)) {
				case "obj_chess_knight":
					if (piece.allied) break;
					for (var j = 0; j < 8; j++) {
						var death_pos_x = piece.x;
						var death_pos_y = piece.y;
						if (j == 0) {death_pos_x += 6; death_pos_y -= 12;}
						if (j == 1) {death_pos_x += 12; death_pos_y -= 6;}
						if (j == 2) {death_pos_x += 12; death_pos_y += 6;}
						if (j == 3) {death_pos_x += 6; death_pos_y += 12;}
						if (j == 4) {death_pos_x -= 6; death_pos_y += 12;}
						if (j == 5) {death_pos_x -= 12; death_pos_y += 6;}
						if (j == 6) {death_pos_x -= 12; death_pos_y -= 6;}
						if (j == 7) {death_pos_x -= 6; death_pos_y -= 12;}
						if (obj_player.x == death_pos_x && obj_player.y == death_pos_y) {
							piece.x = obj_player.x;
							piece.y = obj_player.y;
							obj_player.visible = false;
							alarm[2] = 12;
							var snd_death = audio_play_sound(snd_move, 1, false);
							audio_sound_pitch(snd_death, 0.4);
						}
					}
					break;
				default:
					break;
			}
		}
	}

/*
} until (loop_game_state == false);

