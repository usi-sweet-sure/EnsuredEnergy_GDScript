extends Control

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer2"


func _ready() -> void:
	hide()
	InfoFramesManager.show_frame.connect(_on_manager_show_frame)
	InfoFramesManager.hide_frame.connect(_on_manager_hide_frame)


func _on_manager_show_frame(frame: String) -> void:
	if frame == InfoFramesManager.EMISSIONS_FRAME:
		animation_player.play("info_frame_appears")


func _on_manager_hide_frame(frame: String) -> void:
	if frame == InfoFramesManager.EMISSIONS_FRAME:
		animation_player.play("info_frame_goes_away")


func _on_open_info_box_button_pressed():
	if not visible:
		InfoFramesManager.show_frame_requested.emit(InfoFramesManager.EMISSIONS_FRAME)
	else:
		InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.EMISSIONS_FRAME)


func _on_close_button_pressed() -> void:
	InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.EMISSIONS_FRAME)
