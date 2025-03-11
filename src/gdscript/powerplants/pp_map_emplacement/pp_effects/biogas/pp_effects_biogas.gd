extends Node2D

@onready var pipe0: Sprite2D = $Pipe0
@onready var pipe1: Sprite2D = $Pipe1
@onready var pipe2: Sprite2D = $Pipe2

var is_construction_animation_finished = false


func _ready():
	var pp_scene: PpScene = get_parent()
	
	# Disables the effects during the  build animation
	if not pp_scene.built_on_start:
		pipe0.visible = false
		pipe1.visible = false
		pipe2.visible = false
		
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.construction_animation_finished.connect(construction_animation_finished)
	pp_scene.destruction_animation_requested.connect(destruction_animation_started)
	

func effects_off(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	pipe0.visible = false
	pipe1.visible = false
	pipe2.visible = false
	
	
func effects_on(_metrics: PowerplantMetrics):
	if is_construction_animation_finished:
		pipe0.visible = true
		pipe1.visible = true
		pipe2.visible = true


func construction_animation_finished(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	pipe0.visible = true
	pipe1.visible = true
	pipe2.visible = true


func destruction_animation_started(_metrics: PowerplantMetrics):
	# This hides the particles instantly
	pipe0.visible = false
	pipe1.visible = false
	pipe2.visible = false
