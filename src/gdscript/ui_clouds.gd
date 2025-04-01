extends AnimationPlayer


func _ready() -> void:
	Gameloop.end_toggled.connect(_on_end_toggled)
	
	
func _on_end_toggled(toggle: bool) -> void:
	if toggle:
		play("show_map")
	else:
		play("show_end")
