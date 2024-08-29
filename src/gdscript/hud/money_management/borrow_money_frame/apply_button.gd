extends TextureButton


func _on_slider_value_changed(value):
	disabled = value == 0
