extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var cpu_particles_2d_3: CPUParticles2D = $CPUParticles2D3

var is_construction_animation_finished = false

func _ready():
	var pp_scene: PpScene = get_parent()
	
	# Disables the effects during the  build animation
	if not pp_scene.built_on_start:
		cpu_particles_2d.emitting = false
		cpu_particles_2d_2.emitting = false
		cpu_particles_2d_3.emitting = false
		
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.construction_animation_finished.connect(construction_animation_finished)
	

func effects_off(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = false
	cpu_particles_2d_2.emitting = false
	cpu_particles_2d_3.emitting = false
	
	
func effects_on(_metrics: PowerplantMetrics):
	if is_construction_animation_finished:
		cpu_particles_2d.emitting = true
		cpu_particles_2d_2.emitting = true
		cpu_particles_2d_3.emitting = true


func construction_animation_finished(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	cpu_particles_2d_3.emitting = true
