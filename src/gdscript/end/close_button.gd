extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	HttpManager.http_request_active_updated.connect(_on_request_active_updated)


func _on_request_active_updated(active: bool):
	disabled = active
