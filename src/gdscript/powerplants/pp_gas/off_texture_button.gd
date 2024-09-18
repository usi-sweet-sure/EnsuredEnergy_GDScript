extends TextureButton


func _ready():
	visible = false
	set_modulate(Color(0.5, 0.5, 0.5))


func _on_mouse_entered():
	set_modulate(Color(0.75, 0.75, 0.75))


func _on_mouse_exited():
	set_modulate(Color(0.5, 0.5, 0.5))
