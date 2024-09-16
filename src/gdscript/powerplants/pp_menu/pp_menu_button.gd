extends TextureRect

@onready var animation_player = $AnimationPlayer


func _on_button_mouse_entered():
	# Original position is (x,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, -15), 0.1)

	animation_player.play("info_frame_show")
	

func _on_button_mouse_exited():
	# Original position is (x,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 0), 0.1)
	
	animation_player.play("info_frame_hide")
