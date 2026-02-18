/// @description Insert description here
// You can write your code in this editor
draw_self()
draw_set_halign(fa_left)
draw_set_valign(fa_top)

if lobby_id != -1 {
	draw_text_transformed(bbox_left+10,y-20,"LobbyID: " + string(lobby_id),.5,.5,0)
	draw_text_transformed(bbox_left+10,y-10,"Creator: " + lobby_creator,.5,.5,0)
	draw_text_transformed(bbox_left+10,y,"MapName: " + string(lobby_map),.5,.5,0)
} else {
	draw_text(bbox_left+10,y,"Searching...")
}