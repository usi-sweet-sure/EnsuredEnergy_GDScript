extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var cpu_particles_2d_3: CPUParticles2D = $CPUParticles2D3


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = false
	cpu_particles_2d_2.emitting = false
	cpu_particles_2d_3.emitting = false
	
	
func effects_on(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	cpu_particles_2d_3.emitting = true
