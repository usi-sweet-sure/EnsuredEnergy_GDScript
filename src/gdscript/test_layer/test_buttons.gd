# To be deleted, edit this script as you wish
extends Control

@onready var button_top = $ButtonTop
@onready var button_bottom = $ButtonBottom


func _ready():
	button_top.text = "end"
	button_bottom.text = "request 2"


func _on_button_top_pressed():
	Gameloop.game_ended.emit()
	
	
func _on_button_bottom_pressed():
	HttpManager.make_request("https://api.github.com/repos/godotengine/godot/releases/latest")
