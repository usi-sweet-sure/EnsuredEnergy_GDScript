extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	animation_player.stop()
	
	
func effects_on(_metrics: PowerplantMetrics):
	animation_player.play("rotate_clockwise")
