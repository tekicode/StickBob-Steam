/// @description
// You can write your code in this editor

is_game_restarting = false;
global.gameParams = {
				numberPlayers: 0,
				mapSelection: 0,
				playerColor: 0
}
if steam_initialised() then show_debug_message("Steam Initialized!")