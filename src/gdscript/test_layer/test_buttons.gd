# To be deleted, edit this script as you wish
extends Control

@onready var button_top = $ButtonTop
@onready var button_bottom = $ButtonBottom
@onready var http_request_indicator = $HttpRequestIndicator


func _ready():
	button_top.text = "Trigger the end"
	button_bottom.text = "Enable graph button"
	HttpManager.http_request_active_updated.connect(_on_http_request_active_updated)
	_on_http_request_active_updated(HttpManager.http_request_active)


func _on_button_top_pressed():
	Gameloop.game_ended.emit()
	
	
func _on_button_bottom_pressed():
	Gameloop.enable_graphs_button.emit()
	

func _on_http_request_active_updated(active: bool):
	http_request_indicator.visible = active
