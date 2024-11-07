extends Node2D

@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	Gameloop.enable_graphs_button.connect(_on_enable_graphs_button)


func _on_enable_graphs_button():
	animation_player.play("appear_then_lock")
