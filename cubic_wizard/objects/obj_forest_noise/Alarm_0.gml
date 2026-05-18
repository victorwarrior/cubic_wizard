/// @description Insert description here
// You can write your code in this editor
var snd = audio_play_sound(snd_bird, 1, false);
// U, U, D, U, D, D, D, U
switch (tick) {
	case 0:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 1.1);
		break;
	case 1:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 1.1);
		break;
	case 2:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 0.7);
		break;
	case 3:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 1.1);
		break;
	case 4:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 0.7);
		break;
	case 5:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 0.7);
		break;
	case 6:
		alarm[0] = irandom_range(100, 150);
		audio_sound_pitch(snd, 0.7);
		break;
	case 7:
		alarm[0] = irandom_range(300, 600);
		audio_sound_pitch(snd, 1.1);
		break;
}
tick = (tick+1) mod 8;