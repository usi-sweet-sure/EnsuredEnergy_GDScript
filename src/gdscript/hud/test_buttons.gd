# To be deleted, edit this script as you wish
extends Control


func _on_button_top_pressed():
	Poc.perform_requests_in_sequence()

func _on_button_bottom_pressed():
	Poc.perform_requests_in_sequence()
