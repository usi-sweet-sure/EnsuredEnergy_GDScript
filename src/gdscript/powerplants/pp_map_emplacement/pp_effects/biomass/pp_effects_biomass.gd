extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)


func effects_off(_metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = false
	cpu_particles_2d_2.emitting = false
	
	
func effects_on(metrics: PowerplantMetrics):
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	_adapt_to_current_level(metrics.current_upgrade, metrics.max_upgrade)


func _update_fumes_intencity(particles: CPUParticles2D, intensity_percentage: float):
	var color_ramp = particles.color_ramp
	
	var new_transparancy = color_ramp.get_color(1)
	new_transparancy.a = intensity_percentage / 100.0
	
	color_ramp.set_color(1, new_transparancy)


func _adapt_to_current_level(current_level: int, max_level: int):
	# Levels start counting at 0, but we never want the percentage to
	# be zero, so we add one. (This is also what the user sees in the game btw)
	current_level += 1
	max_level += 1
	
	var transparency_percentage = 100.0 / max_level * current_level
	_update_fumes_intencity(cpu_particles_2d, transparency_percentage)
	_update_fumes_intencity(cpu_particles_2d_2, transparency_percentage)


func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	_adapt_to_current_level(metrics.current_upgrade, metrics.max_upgrade)


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	_adapt_to_current_level(metrics.current_upgrade, metrics.max_upgrade)
