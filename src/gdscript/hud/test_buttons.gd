# To be deleted, edit this script as you wish
extends Control


func _on_button_top_pressed():
	ShockManager.pick_shock()
	ShockManager.apply_shock()
	
func _on_button_bottom_pressed():
	pass
