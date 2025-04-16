extends Node

signal show_frame_requested(frame: String)
signal hide_frame_requested(frame: String)
signal show_frame(frame: String)
signal hide_frame(frame: String)

var MONEY_FRAME := "money"
var EMISSIONS_FRAME := "emissions"
var LAND_USE_FRAME := "land_use"
var WINTER_FRAME := "winter"
var SUMMER_FRAME := "summer"
var HIDE_ANIMATION_TIME := 0.3
var SHOW_ANIMATION_TIME := 0.4

var current_frame = ""


func _ready() -> void:
	show_frame_requested.connect(_on_show_frame_requested)
	hide_frame_requested.connect(_on_hide_frame_requested)


func _on_show_frame_requested(frame: String) -> void:
	print("show " + frame)
	print("previous frame: " + current_frame)
	if current_frame != "":
		hide_frame.emit(current_frame)
		var timer = get_tree().create_timer(HIDE_ANIMATION_TIME)
		await timer.timeout
		
	current_frame = frame
	print("current frame: " + current_frame)
	show_frame.emit(frame)

	
func _on_hide_frame_requested(frame: String) -> void:
	print("hide " + frame)
	current_frame = ""
	hide_frame.emit(frame)
