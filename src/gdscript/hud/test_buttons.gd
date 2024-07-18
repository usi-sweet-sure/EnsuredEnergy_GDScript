# To be deleted, edit this script as you wish
extends Control


func _on_button_top_pressed():
	Gameloop.co2_emissions += 10
	Gameloop.imports_emissions += 10

func _on_button_bottom_pressed():
	Gameloop.co2_emissions -= 10
	Gameloop.imports_emissions -= 10
