extends Node2D

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	var is_snow = bool(randi_range(0, 1))
	color_rect.material.set_shader_parameter("is_snow", is_snow)
