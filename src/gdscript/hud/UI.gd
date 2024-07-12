extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)

# If the player supplies enough energy in summer and winter, can go to the next turn
func _on_energy_supply_updated():
		$NextTurn.disabled = !Gameloop._check_supply()


func _on_next_turn_pressed():
	pass # Replace with function body.
