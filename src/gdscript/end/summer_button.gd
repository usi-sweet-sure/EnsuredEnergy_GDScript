extends TextureButton


func _on_graph_context_changed(context: String):
	set_pressed_no_signal(context == "summer")
