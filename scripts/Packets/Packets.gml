
// Network packet type identifiers.
// These values are written as the first byte of every packet so the
// receiver can dispatch to the correct handler.
//
// Flow overview:
//   Client → Server : CLIENT_PLAYER_INPUT  (raw key/mouse data)
//   Server → Client : SERVER_PLAYER_INPUT  (relays host input so clients can simulate the host)
//   Server → Client : PLAYER_POSITION      (authoritative position broadcast each tick)
//   Server → Client : SPAWN_SELF           (tells a joining client where to place their own character)
//   Server → Client : SPAWN_OTHER          (tells existing clients about a newly spawned peer)
//   Server → Client : SYNC_PLAYERS         (JSON snapshot of the full player list on join)
enum NETWORK_PACKETS {
	CLIENT_PLAYER_INPUT = 10,  // client → server: xInput, yInput, runKey, actionKey, mouseAngle
	SERVER_PLAYER_INPUT = 11,  // server → clients: same fields plus steamID of the player
	PLAYER_POSITION     = 12,  // server → clients: steamID + x + y (u16 each)
	SPAWN_OTHER         = 97,  // server → clients: a peer has joined; includes their steamID + start pos
	SPAWN_SELF          = 98,  // server → new client: where the joining player should spawn
	SYNC_PLAYERS        = 99   // server → new client: full JSON player-list snapshot
}

/// pkt_schema(type) → array of [field_name, buffer_type] pairs, or undefined.
///
/// Single source of truth for every binary packet's layout.
/// SYNC_PLAYERS is excluded — it uses a raw JSON string payload.
///
/// Migration path — to extend any packet with a new field:
///   1. Append [ "fieldName", buffer_type ] to the matching array below.
///   2. Include the field in the data struct you pass to pkt_write().
///   3. pkt_read() picks it up automatically on the receive side.
///   4. Update any code that consumes the struct returned by pkt_read()
///      to use the new field (e.g. apply it to the player instance).
function pkt_schema(_type) {
	static _s = undefined;
	if (_s == undefined) {
		_s = array_create(100, undefined);

		_s[NETWORK_PACKETS.CLIENT_PLAYER_INPUT] = [
			["xInput",     buffer_s8 ],
			["yInput",     buffer_s8 ],
			["runKey",     buffer_u8 ],
			["actionKey",  buffer_u8 ],
			["mouseAngle", buffer_s16],
		];

		_s[NETWORK_PACKETS.SERVER_PLAYER_INPUT] = [
			["steamID",    buffer_u64],
			["xInput",     buffer_s8 ],
			["yInput",     buffer_s8 ],
			["runKey",     buffer_u8 ],
			["actionKey",  buffer_u8 ],
			["mouseAngle", buffer_s16],
		];

		_s[NETWORK_PACKETS.PLAYER_POSITION] = [
			["steamID",    buffer_u64],
			["x",          buffer_u16],
			["y",          buffer_u16],
		];

		_s[NETWORK_PACKETS.SPAWN_SELF] = [
			["x",          buffer_u16],
			["y",          buffer_u16],
		];

		_s[NETWORK_PACKETS.SPAWN_OTHER] = [
			["x",          buffer_u16],
			["y",          buffer_u16],
			["steamID",    buffer_u64],
		];
	}
	return _s[_type];
}
