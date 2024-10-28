extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	HttpManager.http_request_active_updated.connect(_on_http_request_updated)
	Gameloop.game_ended.connect(_on_game_ended)
	
	
func _on_http_request_updated(active: bool):
	if active:
		show()
		animation_player.play("loading")
	else:
		hide()
		animation_player.stop()


func _on_game_ended():
	HttpManager.http_request_active_updated.disconnect(_on_http_request_updated)
	hide()
