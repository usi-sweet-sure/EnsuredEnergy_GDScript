extends Node2D

@onready var particles: Array[CPUParticles2D] = [$blue_water, $white_water, $falling_leaves, $falling_leaves2, $falling_leaves3, $falling_leaves4, $falling_leaves5]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var foliage: Array = [$trunk, $foliage1, $foliage2, $foliage3, $foliage4, $foliage5]

func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	for element in foliage:
		element.hide()
		
	for particle in particles:
		particle.emitting = false
		
	animation_player.stop()
	animation_player_2.stop()
	
	
	
	
func effects_on(_metrics: PowerplantMetrics):
	for element in foliage:
		element.show()
		
	for particle in particles:
		particle.emitting = true
		
	animation_player.play("foliage_breath")
	await get_tree().create_timer(1).timeout
	animation_player_2.play("foliage_breath")
