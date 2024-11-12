extends Node2D

@onready var blue_water: CPUParticles2D = $blue_water
@onready var white_water: CPUParticles2D = $white_water
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	blue_water.emitting = false
	white_water.emitting = false
	animation_player.stop()
	animation_player_2.stop()
	
	
func effects_on(_metrics: PowerplantMetrics):
	blue_water.emitting = true
	white_water.emitting = true
	animation_player.play("foliage_breath")
	await get_tree().create_timer(1).timeout
	animation_player_2.play("foliage_breath")
