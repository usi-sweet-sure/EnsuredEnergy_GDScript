extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)


func effects_off(_metrics: PowerplantMetrics):
	animation_player.stop()
	cpu_particles_2d.emitting = false
	
	
func effects_on(_metrics: PowerplantMetrics):
	animation_player.play("rotate_clockwise")
	cpu_particles_2d.emitting = true
