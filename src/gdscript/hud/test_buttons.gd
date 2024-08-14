# To be deleted, edit this script as you wish
extends Control

@onready var button_top = $ButtonTop
@onready var button_bottom = $ButtonBottom


func _ready():
	button_top.text = "Open graphs"
	button_bottom.text = "Next turn"


func _on_button_top_pressed():
	Gameloop.toggle_graphs.emit()
	
	
func _on_button_bottom_pressed():
	Gameloop.current_turn += 1
	Gameloop.next_turn.emit()
