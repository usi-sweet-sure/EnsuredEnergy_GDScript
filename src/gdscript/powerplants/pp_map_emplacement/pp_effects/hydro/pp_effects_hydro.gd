extends Node2D

@onready var particles: Array[CPUParticles2D] = [$blue_water, $white_water, $falling_leaves, $falling_leaves2, $falling_leaves3, $falling_leaves4, $falling_leaves5]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var foliage: Array = [$trunk, $foliage1, $foliage2, $foliage3, $foliage4, $foliage5]

var WHITE_WATER_MAX_TRANSPARENCY = 0.35

func _ready():
	print("ready")
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_adapt_to_current_upgrade)
	pp_scene.powerplant_downgraded.connect(_adapt_to_current_upgrade)


func effects_off(_metrics: PowerplantMetrics):
	for element in foliage:
		element.hide()
		
	for particle in particles:
		particle.emitting = false
		
	animation_player.stop()
	animation_player_2.stop()
	
	
func effects_on(metrics: PowerplantMetrics):
	_adapt_to_current_upgrade(metrics)
		
	for element in foliage:
		element.show()
		
	for particle in particles:
		particle.emitting = true
		
	animation_player.play("foliage_breath")
	await get_tree().create_timer(1).timeout
	animation_player_2.play("foliage_breath")


func _adapt_to_current_upgrade(metrics: PowerplantMetrics):
	# Levels start counting at 0, but we never want the percentage to
	# be zero, so we add one. (This is also what the user sees in the game btw)
	var max_level = metrics.max_upgrade + 1
	var current_level = metrics.current_upgrade + 1
	
	var new_transparency = 100.0 / max_level * current_level
	_update_water_intensity(new_transparency)
	

func _update_water_intensity(intensity_percentage: float):
	# Blue water
	var blue_water_color_ramp = particles[0].color_ramp
	
	var starting_color = blue_water_color_ramp.get_color(0)
	starting_color.a = intensity_percentage / 100.0
	
	blue_water_color_ramp.set_color(0, starting_color)
	
	
	# White water
	var white_water_color_ramp = particles[1].color_ramp
	var middle_color = white_water_color_ramp.get_color(1)
	
	# White water transparency doesn't go from 0 to 1, but from 0 to
	# WHITE_WATER_MAX_TRANSPARENCY, which is smaller than 1
	var new_transparency = clamp(WHITE_WATER_MAX_TRANSPARENCY / 100.0 * intensity_percentage, 0.20, WHITE_WATER_MAX_TRANSPARENCY)

	middle_color.a = new_transparency
	white_water_color_ramp.set_color(1, middle_color)
