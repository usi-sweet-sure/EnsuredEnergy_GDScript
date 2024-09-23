extends TextureButton


func _ready():
	visible = false
	set_modulate(Color(0.5, 0.5, 0.5))


func _on_mouse_entered():
	set_modulate(Color(0.75, 0.75, 0.75))


func _on_mouse_exited():
	set_modulate(Color(0.5, 0.5, 0.5))


func _on_pp_scene_texture_off_changed(image: Image):
	texture_normal = ImageTexture.create_from_image(image)
	
	# Click mask
	var bitmap = BitMap.new()
	# Fill it from the image alpha
	bitmap.create_from_image_alpha(image)
	# Assign it to the mask
	texture_click_mask = bitmap
