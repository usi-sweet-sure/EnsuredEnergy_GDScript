extends TextureButton


func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	Gameloop.energy_demand_updated_summer.connect(_on_energy_demand_updated)
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated)
	Gameloop.game_ended.connect(_on_game_ended)


# If the player supplies enough energy in summer and winter, can go to the next turn
func _on_energy_supply_updated(_value: float):
	disabled = !Gameloop.can_go_to_next_turn()


func _on_imported_energy_amount_updated(_value: float):
	disabled = !Gameloop.can_go_to_next_turn()
	
	
func _on_energy_demand_updated(_value: float):
	disabled = !Gameloop.can_go_to_next_turn()


func _on_game_ended():
	disabled = true
	hide()
