randomize();
zoom = 6;
set_resolution_by_zoom(zoom);
window_set_caption("CUBIC WIZARD");

enum STATE {
	MENU,
	CHECK_FOR_INPUT,
	RECITE,
	MOVEMENT,
	PERFORM_SPELL,
	BOOK,
	INTERACT,
	SELECTING_ACTION,
	RESPONSE
}
enum ACTION {
	MOVEMENT
}
enum GUI_ACTIONS {
	SPELL,
	BOOK,
	INTERACT,
	LENGTH
}
enum SIZES {
	GUI_HEIGHT = 13,
	ACTION_DIST_FROM_CENTER = 10,
}
enum SPELLS {
	RETURN,
	WIND,
	REVEAL,
	INVERT,
	LENGTH
}
enum SPELL_ATTRIBUTE {
	SEQUENCE,
	PRICE,
	ICON,
	LENGTH
}
enum SHOP_ITEMS {
	SPELL_WIND,
	SPELL_INVERT,
	LENGTH
}
enum LETTER {
	U,
	D,
	R,
	L,
	UR,
	UL,
	URD,
	URDL,
	URDLU,
	ULD,
	ULDR,
	ULDRU,
	DR,
	DL,
	DRU,
	DRUL,
	DRULD,
	DLU,
	DLUR,
	DLURD,
	LU,
	LD,
	LUR,
	LURD,
	LURDL,
	LDR,
	LDRU,
	LDRUL,
	RU,
	RD,
	RUL,
	RULD,
	RULDR,
	RDL,
	RDLU,
	RDLUR,
}


var spell_table_temp;
spell_table_temp[SPELLS.RETURN][SPELL_ATTRIBUTE.SEQUENCE] = [LETTER.URDL, LETTER.DLU, LETTER.DR, LETTER.LDR, LETTER.RDL, LETTER.DRULD];
spell_table_temp[SPELLS.REVEAL][SPELL_ATTRIBUTE.SEQUENCE] = [LETTER.U, LETTER.U, LETTER.D, LETTER.U, LETTER.D, LETTER.D, LETTER.D, LETTER.U];
spell_table_temp[SPELLS.WIND][SPELL_ATTRIBUTE.SEQUENCE]   = [LETTER.RDL, LETTER.RDL, LETTER.RDL];
spell_table_temp[SPELLS.WIND][SPELL_ATTRIBUTE.PRICE]      = 100;
spell_table_temp[SPELLS.INVERT][SPELL_ATTRIBUTE.SEQUENCE] = [LETTER.LUR, LETTER.LUR, LETTER.L, LETTER.L, LETTER.L];
spell_table_temp[SPELLS.INVERT][SPELL_ATTRIBUTE.PRICE]    = 200;
spell_table = spell_table_temp;

unlocked_spells = array_create(SPELLS.LENGTH, false);
shop_brought = array_create(SHOP_ITEMS.LENGTH, false);
number_of_unlocked_spells = 0;
unlocked_spells_list = ds_list_create();

spell_to_be_performed = noone;



state = STATE.MENU;
x_dir = 0;
y_dir = 0;
latest_dir = -1;
teleport_x = 0;
teleport_y = 0;
npc_is_adjacent = false;

money = 0;
lent_money = 0;
got_a_key = false;

spd = 2;

gui_actions_selected = 0;
gui_book_selected = 0;




function player_collision(x_dir, y_dir, spd) {
	var wall = noone;
	var collision = false;
	with (obj_player) {
		wall = instance_place(x + x_dir*spd, y + y_dir*spd, obj_parent_wall);
	}
	if (wall != noone) {
		var is_door = false;
		with (wall) {
			if (object_get_name(object_index) == "obj_door") {
				is_door = true;
			}
		}
		if (is_door) {
			if (got_a_key) {
				var snd_destroy_door = audio_play_sound(snd_door, 1, false);
				instance_destroy(wall);
			} else {
				collision = true;
			}
		} else {
			collision = true;
		}
	}
	return collision;
}

function room_teleport(rm, restart) {
	if (restart) {
		room_persistent = false;
		alarm[1] = 1;
	} else {
		money += lent_money;	
	}
	lent_money = 0;
	npc_is_adjacent = false;
	room_goto(rm);
}

function unlock_spell(spell) {
	var snd = audio_play_sound(snd_unlock, 1, false);

	unlocked_spells[spell] = true;
	number_of_unlocked_spells++;
	var temp_list = ds_list_create();
	for (var i = 0; i < SPELLS.LENGTH; i++) {
		if (unlocked_spells[i] == false) continue;
		ds_list_add(temp_list, i);
	}
	unlocked_spells_list = temp_list;
	ds_list_destroy(temp_list);
}