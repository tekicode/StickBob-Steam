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
			global.isPaused = false;
			
            break;
        case 1:
            // Action for "Load Game"
            show_debug_message("Open Save Menu");			
            break;
        case 2:
            // Action for "Options"
            show_debug_message("Open Load Menu");
			break;
        case 3:
			game_restart()
            break;
            // Action for "Exit"
		case 4:	
			game_end(); // Closes the game
            break;
    }
}