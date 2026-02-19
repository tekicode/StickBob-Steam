/// Generic schema-driven packet serialisation / deserialisation.
///
/// Schema format:  [ [field_name, buffer_type], ... ]
/// Each entry describes one field in the packet body (everything after the
/// leading u8 type byte).
///
/// To extend any packet:
///   1. Open Packets.gml and append [ "fieldName", buffer_type ] to the
///      relevant schema inside pkt_schema().
///   2. Pass the new field in the data struct given to pkt_write().
///   That is all — pkt_read picks it up automatically on the receive side.

/// pkt_write(type, schema, data) → buffer
/// Writes the u8 type byte then every field listed in [schema] from [data].
/// Uses a grow buffer so the size never needs to be hardcoded.
/// Caller must buffer_delete() the returned buffer when finished sending.
function pkt_write(_type, _schema, _data) {
	var _b = buffer_create(1, buffer_grow, 1);
	buffer_write(_b, buffer_u8, _type);
	for (var _i = 0; _i < array_length(_schema); _i++) {
		buffer_write(_b, _schema[_i][1], _data[$ _schema[_i][0]]);
	}
	return _b;
}

/// pkt_read(b, schema) → struct
/// Reads every field listed in [schema] from [b] into a fresh struct.
/// The buffer must already be seeked past the type byte before calling.
function pkt_read(_b, _schema) {
	var _data = {};
	for (var _i = 0; _i < array_length(_schema); _i++) {
		_data[$ _schema[_i][0]] = buffer_read(_b, _schema[_i][1]);
	}
	return _data;
}
