instance_destroy(other)

image_speed = 1;
if (sprite_index != sprPlayerDie){
	playerHealth -= 1;
	if(playerHealth <= 0){
		global.stopShooting = true
		sprite_index = sprPlayerDie;
		audio_play_sound(i_fucked_ur_mum, 10, 0)
		
	}

}
if (sprite_index != sprPlayerDie){
	global.stopShooting = false;	
}