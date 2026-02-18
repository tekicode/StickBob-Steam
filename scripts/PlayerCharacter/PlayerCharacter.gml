function variableInitAll(){
	//steam stuff
	localSteamID = steam_get_user_steam_id()
	lobbyHost = steam_lobby_get_owner_id()
	isHost = steam_lobby_is_owner()
	isLocal = (localSteamID == steamID)
	playerID = id
	//collision stuff
	collision_tilemap_id = layer_tilemap_get_id("CollisionLayer");
	collisionObjects = [objSolid, collision_tilemap_id]
	collision = false;
	//timers
	cwjt = 0
	fireCooldown = 10
	currentCooldown = 0
	//bools
	wallJump = 0;
	canJump = true;
	canSlide = false
	isCrawling = false;
	releasedJump = false;
	//playerConfig
	grav = 0.4;
	jumpSpeed = -10
	fallCooldown = 0;
	climbHeight = 8;
	wallJumpTimer = 20;
	//playerVars
	collisionAngle = 0;
}

function variableInitSP(){

	respawn_x = x;
	respawn_y = y;
}

function parallaxDefinition(){
	background_map = ds_map_create();
	background_map[? layer_get_id("bgClouds")] = 0.3;
	background_map[? layer_get_id("bgDistantGround")] = 0.2;
	background_map[? layer_get_id("bgNearGround")] = 0.1;
	background_map[? layer_get_id("bgGroundPath")] = 0;
	background_map[? layer_get_id("bgForeground")] = -0.5;
}

function viewInitSP(){
	vpSizeWidth = 1280
	vpSizeLength = 720
	if(isLocal){
	    view_enabled = true;
		view_visible[1] = true;
		view_wport[1] = vpSizeWidth
		view_hport[1] = vpSizeLength
		camera_set_view_size(view_camera[1], 320, 240);
		surface_resize(application_surface, view_wport[1], view_hport[1]);
		window_set_size(vpSizeWidth, vpSizeLength);
		window_center();
		camera_set_view_size(view_camera[1], 320, 240);
		target_instance = playerID
	}
}
function paddle_movement() {
    var maxSpeedX = 7
	var maxSpeedY = 15
    var accel = 0.3;
	var onGround = place_meeting(x, y+1, collision_tilemap_id );
	var onSolid = place_meeting(x, y+1, objSolid)
    // accelerate
    xSpeed = clamp(xSpeed + xInput * accel, -maxSpeedX, maxSpeedX);	//acceleration
    ySpeed = clamp(ySpeed + yInput * accel, -maxSpeedY, maxSpeedY);	//acceleration
	ySpeed += grav;
    // decelerate to 0 when no input
    if (xInput == 0) {
        if (xSpeed > 0) xSpeed = max(0, xSpeed - accel);
        else if (xSpeed < 0) xSpeed = min(0, xSpeed + accel);
    }
    if (yInput == 0) {
        if (ySpeed > 0) ySpeed = max(0, ySpeed - accel);
        else if (ySpeed < 0) ySpeed = min(0, ySpeed + accel);
    }
	//do stuff if on ground
	if(onGround){
		ySpeed = -0.25
		if(yInput == 0) {
			canJump = true;
			
		}
		fallCooldown = 20;


	}
	if(wallJump == 0 && canJump == true){
		cwjt = wallJumpTimer;	
	}
	if(ySpeed < 10){
		ySpeed+= grav	
	}
	//jumping
	if(cwjt > 0){
		wallJump =1
	}
	if (place_meeting(x + xSpeed, y + ySpeed, objSolid )){
		if (xSpeed > 0){
			collisionAngle = 180;		
		}
		if (xSpeed < 0){
			collisionAngle = 0;
		}	
		wallJump = 0;
		if(canJump == 0 && yInput == -1 && fallCooldown <= 0){
			if(collisionAngle == 0 && xInput == -1 && xSpeed <= .5 ){
				xSpeed = xSpeed	+ 15
				ySpeed -= 15
		}
			else if(collisionAngle == 180 && xInput == 1 && xSpeed <= .5 ){
				xSpeed -= xSpeed + 15
				ySpeed -= 15
			}

		}
	}
	if (place_meeting(x, y + ySpeed, objSolid )){
		canJump = true;
		while (!place_meeting(x, y + sign(ySpeed), objSolid )){
			y += sign(ySpeed);
					wallJump = 0;
			
		}
		ySpeed = 0; // Stop vertical movemen
		if(yInput == -1 && place_meeting(x, y + 1, objSolid ) && canJump){
			ySpeed = jumpSpeed
			canJump = false;
		}
	}
	if (place_meeting(x, y + ySpeed, collision_tilemap_id )){
		while (!place_meeting(x, y + sign(ySpeed), collision_tilemap_id )){
			y += sign(ySpeed);
			wallJump = 0;
		}
		ySpeed = 0; // Stop vertical movemen
		if(yInput == -1 && place_meeting(x, y + 1, collision_tilemap_id ) && canJump){
			ySpeed = jumpSpeed
			canJump = false;
		}
	}
	if (fallCooldown > 0 && !canJump){
		fallCooldown -= 1;
	}	
	if (cwjt >= 0 ){
		cwjt -= 1;
	}
	if (cwjt <= 0){
		cwjt = 0	
		wallJump = 0;
	}

		

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////
	// Enable Slopes //
	///////////////////
if (place_meeting(x + xSpeed, y, objSolid))
{
    // Move pixel by pixel towards the wall until contact
    while (!place_meeting(x + sign(xSpeed), y, objSolid))
    {
        x += sign(xSpeed);
    }
	
    //RIGHT SIDE COLLISION

	
	//STOP MOVEMENT
	
	//handle slopes
	//dy gets incremented up the height until first clear pixel. if it is less than climb max player is pushed up
	var dy = 0;
	while(place_meeting(x + xSpeed, y - dy, objSolid) && dy < climbHeight){
		dy++;
	}
	if (!place_meeting(x+ xSpeed, y- dy, objSolid)) {
		//x += xSpeed;
		y -=dy;
	}
	//stop movement
    else {
		xSpeed = 0;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**************/
	/* Slide Code */
	/**************/
	if(yInput == 0 && sprite_index != sprPlayerDie){
		canSlide = true;	
		isCrawling = false
		mask_index = sprPlayerIdle;
	}
	if(yInput == 1){
		if(canSlide && xSpeed > 0){
			xSpeed = xSpeed + 2	
		}
		else if(canSlide && xSpeed < 0){
			xSpeed = xSpeed - 2
		}
		else if(xSpeed >= -.3 && xSpeed <.3){
			isCrawling = true;
		}
		canSlide = false;
	}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	/////////////////////////////////
	// apply final player position //
	/////////////////////////////////
	
    x += xSpeed;
    y += ySpeed;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///////////////////////////
	// Sprite Index Indexer  //
	///////////////////////////
	

if currentCooldown > 0 then --currentCooldown;
}
function playerShoot(){
	if (actionKey == 1 && currentCooldown <= 0){
	var dist = 32;
	gun_distance = 20
	var bullet_x = x + lengthdir_x(dist, mouseAngle);
	var bullet_y = y + lengthdir_y(dist, mouseAngle);
	var bullet = instance_create_layer(bullet_x, bullet_y, "Instances", obj_Bullet)
		bullet.direction = mouseAngle
		bullet.image_angle = bullet.direction
		bullet.owner_id = id
	audio_play_sound(wob_wob_2, 10, 0)
    var _x = x + lengthdir_x(gun_distance, mouseAngle);
    var _y = y + lengthdir_y(gun_distance, mouseAngle);
	effect_create_above(ef_smokeup, _x, _y, .05, c_ltgray);
	effect_create_above(ef_smoke, _x, _y, .05, c_grey);
	effect_create_above(ef_spark, _x, _y, .05, c_orange);
	currentCooldown = fireCooldown
	}
}

function playerSpriteIndexer(){
	var onGround = place_meeting(x, y+1, collision_tilemap_id );
	var onSolid = place_meeting(x, y+1, objSolid)
	if(xSpeed < 3.5 && xSpeed > 0.05 && xInput == 0 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerSkid;
	}
	else if(xSpeed > -3.5 && xSpeed < -0.05 && xInput == 0 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerSkidLeft;
	}
	else if(xSpeed > 0.1 && xInput == 1 && canSlide && global.stopShooting == false){
		sprite_index = sprPlayerRun;
	}
	else if(xSpeed < -.1 && xInput == -1 && canSlide && global.stopShooting == false){
		sprite_index = sprPlayerRunLeft;	
	}else if(xSpeed < 0 && yInput == 1 && isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerCrawlLeft;
		mask_index = sprPlayerCrawlLeft;
	}
	else if(isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerCrawl;
		mask_index = sprPlayerCrawl;	
	}
	else if(xSpeed > 0 && yInput == 1 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerSlide;
		mask_index = sprPlayerSlide;
	}
	else if(xSpeed < 0 && yInput == 1 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerSlideLeft;
		mask_index = sprPlayerSlideLeft;
	}
	else if(ySpeed > 0.5 && yInput!= -1 && !onGround && fallCooldown <= 0 && xSpeed >= 0 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerFalling;
	}
	else if(ySpeed > 0.5 && yInput != -1 && !onGround && fallCooldown <= 0 && xSpeed < 0 && !isCrawling && global.stopShooting == false){
		sprite_index = sprPlayerFallingLeft;
	}
	else if( xInput == 0 && yInput == 0 && xSpeed == 0 && global.stopShooting == false){
		sprite_index = sprPlayerIdle
	}
	
}
