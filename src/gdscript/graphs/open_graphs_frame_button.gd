extends TextureButton


func _ready():
	visible = false


func _on_pressed():
	Gameloop.toggle_graphs.emit()
