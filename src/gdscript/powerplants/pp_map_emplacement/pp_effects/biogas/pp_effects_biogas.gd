extends Node2D

@onready var pipe0: Sprite2D = $Pipe0
@onready var pipe1: Sprite2D = $Pipe1
@onready var pipe2: Sprite2D = $Pipe2

var is_construction_animation_finished = false
@onready var pipes = [$Pipe0, $Pipe1, $Pipe2]
@onready var smokes = [$CPUParticles2D, $CPUParticles2D5, $CPUParticles2D3, $CPUParticles2D2, $CPUParticles2D4]


func _ready():
	var pp_scene: PpScene = get_parent()
	
	# Disables the effects during the  build animation
	if not pp_scene.built_on_start:
		for pipe in pipes:
			pipe.visible = false
			
		set_smokes(0)
		
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)
	pp_scene.construction_animation_finished.connect(construction_animation_finished)
	

func effects_off(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	for pipe in pipes:
		pipe.visible = false
		
	set_smokes(0)
	
	
func effects_on(metrics: PowerplantMetrics):
	if is_construction_animation_finished:
		for pipe in pipes:
			pipe.visible = true
			
		set_smokes(metrics.current_upgrade)
			
		
func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	set_pipes(metrics.current_upgrade, 1)
	set_smokes(metrics.current_upgrade)


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	set_pipes(metrics.current_upgrade, -1)
	set_smokes(metrics.current_upgrade)


func construction_animation_finished(metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	for pipe in pipes:
		pipe.visible = true
		
	set_smokes(metrics.current_upgrade)


func set_pipes(upgrade, factor):
	for pipe in pipes:
		var current_speed = pipe.material.get_shader_parameter("speed")
		var new_speed = current_speed + (factor * upgrade * 2.0)
		
		pipe.material.set_shader_parameter("speed", new_speed)


func set_smokes(upgrade):
		var number_of_visible_smokes = floor((upgrade + 1) / 2.0)
		for i in smokes.size():
			smokes[i].emitting = i + 1 <= number_of_visible_smokes
