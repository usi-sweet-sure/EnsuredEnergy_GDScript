extends TextureButton

var normal_texture


func _ready():
	normal_texture = texture_normal
	# Graphs default to energy so we make it look like pressed
	texture_normal = texture_pressed


func _on_pressed():
	texture_normal = texture_pressed


func _on_environment_button_pressed():
	texture_normal = normal_texture


func _on_economy_button_pressed():
	texture_normal = normal_texture
