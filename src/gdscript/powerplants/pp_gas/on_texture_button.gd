extends TextureButton


func _ready():
	visible = false


func _on_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_mouse_exited():
	set_modulate(Color(1, 1, 1))


func _on_close_button_mouse_entered():
	set_modulate(Color(1.1, 1.1, 1.1))


func _on_close_button_mouse_exited():
	set_modulate(Color(1, 1, 1))
