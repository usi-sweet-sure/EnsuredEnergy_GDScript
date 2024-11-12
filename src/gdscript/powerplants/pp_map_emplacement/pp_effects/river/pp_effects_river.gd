extends Node2D

@onready var blue_water: CPUParticles2D = $blue_water
@onready var white_water: CPUParticles2D = $white_water
@onready var still_water: Sprite2D = $still_water
@onready var still_water_shadow: Sprite2D = $still_water_shadow


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	blue_water.emitting = false
	white_water.emitting = false
	still_water.hide()
	still_water_shadow.hide()
	
	
func effects_on(_metrics: PowerplantMetrics):
	blue_water.emitting = true
	white_water.emitting = true
	still_water.show()
	still_water_shadow.show()
