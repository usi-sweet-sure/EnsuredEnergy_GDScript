extends Node2D

@onready var particle_systems: Array[CPUParticles2D] = [$CPUParticles2D, $CPUParticles2D2]


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_update_fumes)
	pp_scene.powerplant_downgraded.connect(_update_fumes)


func effects_off(_metrics: PowerplantMetrics):
	for system in particle_systems:
		system.emitting = false
	
	
func effects_on(metrics: PowerplantMetrics):
	_update_fumes(metrics)
	
	for system in particle_systems:
		system.emitting = true


func _update_fumes(metrics: PowerplantMetrics):
	# + 1 because base upgrade is 0 and that would mean full transparency, which
	# we don't want
	var intensity_percentage = 100.0 / metrics.max_upgrade * (metrics.current_upgrade + 1)

	for system in particle_systems:
		var color_ramp = system.color_ramp
	
		var starting_color = color_ramp.get_color(0)
		starting_color.a = intensity_percentage / 100.0
		
		color_ramp.set_color(0, starting_color)
