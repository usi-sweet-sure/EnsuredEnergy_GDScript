extends Control

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var value_2: HBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/Value2
@onready var text_2: HBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer/Text2


func _ready() -> void:
	hide()
	value_2.hide()
	text_2.hide()
	InfoFramesManager.show_frame.connect(_on_manager_show_frame)
	InfoFramesManager.hide_frame.connect(_on_manager_hide_frame)


func _on_manager_show_frame(frame: String) -> void:
	if frame == InfoFramesManager.LAND_USE_FRAME:
		animation_player.play("info_frame_appears")


func _on_manager_hide_frame(frame: String) -> void:
	if frame == InfoFramesManager.LAND_USE_FRAME:
		animation_player.play("info_frame_goes_away")


func _on_open_info_box_button_pressed():
	if not visible:
		InfoFramesManager.show_frame_requested.emit(InfoFramesManager.LAND_USE_FRAME)
	else:
		InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.LAND_USE_FRAME)


func _on_close_button_pressed() -> void:
	InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.LAND_USE_FRAME)
