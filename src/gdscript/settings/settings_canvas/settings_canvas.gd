extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.toggle_settings.connect(_on_toggle_settings)


func _on_toggle_settings():
	visible = not visible
