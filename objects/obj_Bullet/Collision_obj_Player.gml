/// @description Slow down other Players
if (other.id != owner_id){
	instance_destroy()
	show_debug_message("kill! ID:" + string(other.id) + " BulletID : " + string(owner_id))
} else {
	instance_destroy()
}