draw_set_font(fontMenu)
draw_set_color(c_white)

draw_set_halign(fa_center);
draw_set_valign(fa_top);

var hwidth = display_get_gui_width()
draw_text(hwidth/2 , 0, string(track_list[track_position]));