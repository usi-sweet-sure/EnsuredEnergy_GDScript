extends Node2D

@onready var god_rays: ColorRect = $GodRays
@onready var highlight: ColorRect = $Highlight

var is_construction_animation_finished = false

func _ready() -> void:
	var pp_scene: PpScene = get_parent()
	# Disables the effects during the  build animation
	if not pp_scene.built_on_start:
		god_rays.hide()
		highlight.hide()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)
	pp_scene.construction_animation_finished.connect(construction_animation_finished)


func effects_off(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	god_rays.hide()
	highlight.hide()
	
	
func effects_on(metrics: PowerplantMetrics):
	if is_construction_animation_finished:
		highlight.show()
		god_rays.hide()
		
		if metrics.current_upgrade > metrics.min_upgrade:
			god_rays.show()
			var current_upgrade = metrics.current_upgrade - 1
			var intensity = float(current_upgrade - metrics.min_upgrade) / (metrics.max_upgrade - metrics.min_upgrade)
			god_rays.material.set_shader_parameter("ray2_intensity", intensity)
			

func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	god_rays.show()
	# Goes from 0 to 1
	var current_upgrade = metrics.current_upgrade - 1
	var intensity = float(current_upgrade - metrics.min_upgrade) / (metrics.max_upgrade - metrics.min_upgrade)
	god_rays.material.set_shader_parameter("ray2_intensity", intensity)


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	if metrics.current_upgrade == metrics.min_upgrade:
		god_rays.hide()
	else:
		var current_upgrade = metrics.current_upgrade - 1
		var intensity = float(current_upgrade - metrics.min_upgrade) / (metrics.max_upgrade - metrics.min_upgrade)
		god_rays.material.set_shader_parameter("ray2_intensity", intensity)


func construction_animation_finished(metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	effects_on(metrics)
