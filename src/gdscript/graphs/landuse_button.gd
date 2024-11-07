extends TextureButton

var normal_texture


func _ready():
	normal_texture = texture_normal


func _on_graphs_context_changed(context: String):
	if context == "landuse":
		texture_normal = texture_pressed
	else:
		texture_normal = normal_texture
