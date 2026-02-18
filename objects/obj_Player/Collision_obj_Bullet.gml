show_debug_message(string(other.owner_id))
show_debug_message(string(localSteamID))
instance_destroy(other)

if (sprite_index != sprPlayerDie){
	image_speed = 1;
	sprite_index = sprPlayerDie;
	audio_play_sound(i_fucked_ur_mum, 10, 0)
}
if (sprite_index != sprPlayerDie){
	global.stopShooting = false;	
}

if (other.owner_id != localSteamID){

	if(random(10) >= 6){
		x = 200

	}
	else{
		x = room_width - 200;		
	}
	y = room_height / 2;
}

	if(isLocal){
		audio_play_sound(i_fucked_ur_mum, 10, 0)
	}
	if(!isLocal){
		audio_play_sound(crunch, 10, 0)
	}