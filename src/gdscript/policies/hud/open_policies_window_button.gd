extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(166, 80)


func _on_pressed():
	Gameloop.toggle_policies_window.emit()
