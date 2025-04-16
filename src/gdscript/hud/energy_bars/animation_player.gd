extends AnimationPlayer


func _ready() -> void:
	InfoFramesManager.show_frame.connect(_on_show_frame)
	InfoFramesManager.hide_frame.connect(_on_hide_frame)
	

func _on_show_frame(frame: String) -> void:
	if frame == InfoFramesManager.WINTER_FRAME:
		play("winter_info_frame_appears")
	elif frame == InfoFramesManager.SUMMER_FRAME:
		play("summer_info_frame_appears")
	

func _on_hide_frame(frame: String) -> void:
	if frame == InfoFramesManager.WINTER_FRAME:
		play("winter_info_frame_goes_away")
	elif frame == InfoFramesManager.SUMMER_FRAME:
		play("summer_info_frame_goes_away")
