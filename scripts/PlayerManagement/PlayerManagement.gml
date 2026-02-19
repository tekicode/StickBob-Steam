// Shared player management utilities used by both obj_Server and obj_Client.
// Covers spawn-point lookup, network packet serialisation / deserialisation,
// player search, and position broadcasting.

// Returns the world-space {x, y} of the spawn point assigned to _player
// (the spawn point instance index, matching the player's lobby slot).
// Falls back to {x:0, y:0} if no matching spawn point exists in the room.
function grab_spawn_point(_player) {
	var _spawnPoint = instance_find(obj_SpawnPoint, _player)
	if _spawnPoint == noone return {x:0, y:0};
	return {x:_spawnPoint.x, y:_spawnPoint.y}
}


///@self obj_Client
// Serialises local input into a CLIENT_PLAYER_INPUT packet and sends it to
// the server (_lobby_host).  The server will apply these values to this
// client's player instance and relay them to other clients.
function send_player_input(_input, _lobby_host){
	// Convert raw key booleans to signed axis values before transmitting.
	var _b = pkt_write(NETWORK_PACKETS.CLIENT_PLAYER_INPUT, pkt_schema(NETWORK_PACKETS.CLIENT_PLAYER_INPUT), {
		xInput:     (_input.rightKey - _input.leftKey),
		yInput:     (_input.downKey  - _input.upKey),
		runKey:     _input.runKey,
		actionKey:  _input.actionKey,
		mouseAngle: point_direction(x, y, mouse_x, mouse_y),
	});
	steam_net_packet_send(_lobby_host, _b);
	buffer_delete(_b);
}

///@description Player Input Packet Reading for server/client
// Deserialises an input packet from buffer _b and applies the values to the
// matching player instance.
//   _steam_id  – pass -1 when reading a SERVER_PLAYER_INPUT (steamID is in
//                the buffer); pass an explicit ID when reading
//                CLIENT_PLAYER_INPUT (steamID comes from the Steam API).
// Returns a struct with all parsed fields, or nothing if the player is not found.
function receive_player_input(_b, _steam_id=-1){
	// SERVER_PLAYER_INPUT includes steamID in the payload; CLIENT_PLAYER_INPUT does not.
	var _schema_type = (_steam_id == -1)
		? NETWORK_PACKETS.SERVER_PLAYER_INPUT
		: NETWORK_PACKETS.CLIENT_PLAYER_INPUT;
	var _p = pkt_read(_b, pkt_schema(_schema_type));
	if _steam_id == -1 then _steam_id = _p.steamID;

	var _player = find_player_by_steam_id(_steam_id);
	if _player == noone return;  // player may not have spawned yet — drop the packet
	_player.xInput     = _p.xInput;
	_player.yInput     = _p.yInput;
	_player.runKey     = _p.runKey;
	_player.actionKey  = _p.actionKey;
	_player.mouseAngle = _p.mouseAngle;

	return {steamID: _steam_id, xInput: _p.xInput, yInput: _p.yInput, runKey: _p.runKey, actionKey: _p.actionKey, mouseAngle: _p.mouseAngle};
}

///@self obj_Client, obj_Server
// Searches playerList for an entry whose character instance has the given
// steamID.  Returns the instance reference, or noone if not found.
function find_player_by_steam_id(_steam_id){
	for (var _i = 0; _i < array_length(playerList); _i++){
		var _player = playerList[_i].character
		if _player == undefined continue;
		if _player.steamID == _steam_id return _player;
	}
	return noone;
}

//@self obj_Server
// Sends a PLAYER_POSITION packet for every player to every non-host client.
// Called each tick by the server to keep client positions authoritative.
function send_player_positions() {
	for (var _i = 0; _i < array_length(playerList); _i++){
		var _player = playerList[_i];
		if _player.character == undefined then continue;
		if _player.steamID  == undefined then continue;
		var _b = pkt_write(NETWORK_PACKETS.PLAYER_POSITION, pkt_schema(NETWORK_PACKETS.PLAYER_POSITION), {
			steamID: _player.steamID,
			x:       _player.character.x,
			y:       _player.character.y,
		});
		// Broadcast to every non-host client
		for (var _k = 0; _k < array_length(playerList); _k++){
			if (playerList[_k].steamID != obj_Server.steamID) {
				steam_net_packet_send(playerList[_k].steamID, _b);
			}
		}
		buffer_delete(_b);
	}
}

//@self obj_Client
// Reads a PLAYER_POSITION packet from _b and snaps the matching player
// instance to the server-authoritative coordinates.
function update_player_position(_b) {
	var _p = pkt_read(_b, pkt_schema(NETWORK_PACKETS.PLAYER_POSITION));
	for (var _i = 0; _i < array_length(playerList); _i++){
		if (_p.steamID == playerList[_i].steamID) {
			if playerList[_i].character == undefined then continue;
			playerList[_i].character.netX = _p.x;
			playerList[_i].character.netY = _p.y;
			playerList[_i].character.hasNetPos = true;
		}
	}
}
