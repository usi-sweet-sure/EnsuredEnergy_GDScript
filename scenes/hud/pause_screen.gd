extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.pause_requested.connect(_on_pause_requested)
	

func _on_pause_requested():
	get_tree().paused = true
