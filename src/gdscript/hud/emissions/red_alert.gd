extends Sprite2D


@onready var animation_player = $"../AnimationPlayer"

var emissions_max_value = 5


func _ready():
	set_self_modulate(Color(1, 1, 1, 0))
	Gameloop.co2_emissions_updated.connect(_on_emissions_updated)
	_on_emissions_updated(Gameloop.co2_emissions)

	
func _on_emissions_updated(emissions: float):
	if emissions >= emissions_max_value:
		animation_player.play("red_alert_blink")
	else:
		animation_player.stop()
