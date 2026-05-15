randomize();
zoom = 5;
set_resolution_by_zoom(zoom);
window_set_caption("AUTO FACE DUNGEON");

enum STATE {
	CHECK_FOR_INPUT,
	RECITE,
	MOVEMENT,
	PERFORM_SPELL,
	BOOK,
	SELECTING_ACTION,
	RESPONSE
}
enum ACTION {
	MOVEMENT
}
enum GUI_ACTIONS {
	SPELL,
	BOOK,
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
	LENGTH
}
enum SPELL_ATTRIBUTE {
	SEQUENCE,
	ICON,
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
spell_table_temp[SPELLS.RETURN][SPELL_ATTRIBUTE.SEQUENCE] = [LETTER.RULDR, LETTER.R, LETTER.L];
spell_table_temp[SPELLS.REVEAL][SPELL_ATTRIBUTE.SEQUENCE] = [LETTER.U, LETTER.U, LETTER.D, LETTER.U, LETTER.D, LETTER.D, LETTER.D, LETTER.U];
spell_table_temp[SPELLS.WIND][SPELL_ATTRIBUTE.SEQUENCE]   = [LETTER.LURDL, LETTER.DLURD, LETTER.L, LETTER.L, LETTER.L];
spell_table = spell_table_temp;

unlocked_spells = array_create(SPELLS.LENGTH, false);
number_of_unlocked_spells = 0;
unlocked_spells_list = ds_list_create();

spell_to_be_performed = noone;



state = STATE.CHECK_FOR_INPUT;
x_dir = 0;
y_dir = 0;
teleport_x = 0;
teleport_y = 0;

spd = 2;

gui_actions_selected = 0;
gui_book_selected = 0;


room_goto_next();


function player_collision(x_dir, y_dir, spd) {
	var collision = false;
	with (obj_player) {
		collision = place_meeting(x + x_dir*spd, y + y_dir*spd, obj_parent_wall);
	}
	return collision;
}