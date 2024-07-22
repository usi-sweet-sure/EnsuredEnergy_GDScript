# To be deleted, edit this script as you wish
extends Control


func _on_button_top_pressed():
	ShockManager.pick_shock()

func _on_button_bottom_pressed():
	ShockManager.apply_shock()
