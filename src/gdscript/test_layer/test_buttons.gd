# To be deleted, edit this script as you wish
extends Control

@onready var button_top = $ButtonTop
@onready var button_bottom = $ButtonBottom
@onready var http_request_indicator = $HttpRequestIndicator


func _ready():
	button_top.text = "read token"
	button_bottom.text = "no use"
	HttpManager.http_request_active_updated.connect(_on_http_request_active_updated)
	_on_http_request_active_updated(HttpManager.http_request_active)

func _on_button_top_pressed():
	SurveyManager.update_token()
	
	
func _on_button_bottom_pressed():
	pass

func _on_http_request_active_updated(active: bool):
	http_request_indicator.visible = active
