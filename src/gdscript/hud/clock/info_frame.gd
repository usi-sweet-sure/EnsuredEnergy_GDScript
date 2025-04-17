extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()
	InfoFramesManager.show_frame.connect(_on_show_frame)
	InfoFramesManager.hide_frame.connect(_on_hide_frame)


func _on_turn_info_pressed() -> void:
	if visible:
		InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.CLOCK_FRAME)
	else:
		InfoFramesManager.show_frame_requested.emit(InfoFramesManager.CLOCK_FRAME)


func _on_show_frame(frame: String) -> void:
	if frame == InfoFramesManager.CLOCK_FRAME:
		animation_player.play("info_frame_appears")
	
	
func _on_hide_frame(frame: String) -> void:
	if frame == InfoFramesManager.CLOCK_FRAME:
		animation_player.play("info_frame_goes_away")


func _on_close_button_pressed() -> void:
	InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.CLOCK_FRAME)
