extends CanvasLayer

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	HttpManager.http_request_active_updated.connect(_on_http_request_active_updated)
	
	
func _on_http_request_active_updated(active: bool):
	if active:
		show()
		animation_player.play("loading")
	else:
		hide()
		animation_player.stop()
