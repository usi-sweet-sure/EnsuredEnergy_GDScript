extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.available_money_amount_updated.connect(_on_money_change)
	Gameloop.building_costs_updated.connect(_on_money_change)
	Gameloop.energy_import_cost_updated.connect(_on_money_change)
	Gameloop.powerplants_production_costs_updated.connect(_on_money_change)

	_on_money_change(0)
	
	
func _on_money_change(_unused_signal_param):
	text = str(round(Gameloop.available_money_amount + Gameloop.money_per_turn
			- Gameloop.powerplants_production_costs - Gameloop.building_costs 
			- Gameloop.borrowed_money_amount * (1.0 + (Gameloop.debt_percentage_on_borrowed_money / 100.0))
			- Gameloop.energy_import_cost))
