extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = false
	
	
func effects_on(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = true
