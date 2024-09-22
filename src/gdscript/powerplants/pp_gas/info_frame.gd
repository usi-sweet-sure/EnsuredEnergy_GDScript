extends TextureRect

var previous_scale = 0

func _on_toggle_info_frame():
	var tween = get_tree().create_tween()
	
	if visible:
		# Stores current scale to reopen at the same scale
		previous_scale = scale
		tween.tween_property(self, "scale", Vector2(0.0 , 0.0), 0.1)
		tween.tween_property(self, "visible", not visible, 0)
	else:
		# A scale bigger than zero means something else changed the scale
		# (in our case this is the camera zoom)
		# We test 0.001 and not zero because tweening to zero puts ths scale to
		# 0.00001 and not really zero
		if scale > Vector2(0.001, 0.001):
			var new_scale = scale
			scale = Vector2()
			visible = not visible
			tween.tween_property(self, "scale", new_scale, 0.1)
		else:
			# No zoom occured
			visible = not visible
			tween.tween_property(self, "scale", previous_scale, 0.1)
	

