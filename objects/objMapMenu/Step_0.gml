// Step Event
// Check for input (Down key - Up key)
menu_move = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);

// Update menu index
menu_index += menu_move;

// Wrap index around the array length (looping menu)
if (menu_index < 0) menu_index = buttons - 1;
if (menu_index > buttons - 1) menu_index = 0;

// Optional: Play a sound when the selection changes
if (menu_index != last_selected) {
    // audio_play_sound(snd_menu_switch, 1, false); // Uncomment and replace with your sound asset
}
last_selected = menu_index;

// Handle selection (Enter/Space key)
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    switch(menu_index) {
        case 0:
            // Action for "New Game"
            show_debug_message("Start New Game");
            	global.server = instance_create_depth(0,0,0,obj_Server)
				global.gameParams.mapSelection = MPB1
				steam_lobby_create(steam_lobby_type_public, global.gameParams.numberPlayers);
            break;
        case 1:
            	global.server = instance_create_depth(0,0,0,obj_Server)
				global.gameParams.mapSelection = MPB2
				steam_lobby_create(steam_lobby_type_public, global.gameParams.numberPlayers);
            break;
        case 2:
            instance_create_layer(x,y,"Instances", objPlayerMenu)
            instance_destroy()
            show_debug_message("Open Options Menu");
            break;
        case 3:
            // Action for "Exit"
            game_end(); // Closes the game
            break;
    }
}