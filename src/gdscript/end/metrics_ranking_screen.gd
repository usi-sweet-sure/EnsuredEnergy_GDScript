extends Control


func _on_graph_context_changed(context: String):
	visible = context == "none"
