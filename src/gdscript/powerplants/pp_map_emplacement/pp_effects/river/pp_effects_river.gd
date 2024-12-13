extends Node2D

@onready var blue_water: CPUParticles2D = $blue_water
@onready var white_water: CPUParticles2D = $white_water
@onready var still_water: Sprite2D = $still_water
@onready var still_water_shadow: Sprite2D = $still_water_shadow

var WHITE_WATER_MAX_TRANSPARENCY = 0.35


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_adapt_to_current_upgrade)
	pp_scene.powerplant_downgraded.connect(_adapt_to_current_upgrade)


func effects_off(_metrics: PowerplantMetrics):
	blue_water.emitting = false
	white_water.emitting = false
	still_water.hide()
	still_water_shadow.hide()
	
	
func effects_on(metrics: PowerplantMetrics):
	_adapt_to_current_upgrade(metrics)
	blue_water.emitting = true
	white_water.emitting = true
	still_water.show()
	still_water_shadow.show()


func _adapt_to_current_upgrade(metrics: PowerplantMetrics):
	# Levels start counting at 0, but we never want the percentage to
	# be zero, so we add one. (This is also what the user sees in the game btw)
	var max_level = metrics.max_upgrade + 1
	var current_level = metrics.current_upgrade + 1
	
	var new_transparency = 100.0 / max_level * current_level
	_update_water_intensity(new_transparency)
	

func _update_water_intensity(intensity_percentage: float):
	# Blue water
	var blue_water_color_ramp = blue_water.color_ramp
	
	var starting_color = blue_water_color_ramp.get_color(0)
	starting_color.a = intensity_percentage / 100.0
	
	blue_water_color_ramp.set_color(0, starting_color)
	
	
	# White water
	var white_water_color_ramp = white_water.color_ramp
	var middle_color = white_water_color_ramp.get_color(1)
	
	# White water transparency doesn't go from 0 to 1, but from 0 to
	# WHITE_WATER_MAX_TRANSPARENCY, which is smaller than 1
	var new_transparency = clamp(WHITE_WATER_MAX_TRANSPARENCY / 100.0 * intensity_percentage, 0.20, WHITE_WATER_MAX_TRANSPARENCY)

	middle_color.a = new_transparency
	white_water_color_ramp.set_color(1, middle_color)
