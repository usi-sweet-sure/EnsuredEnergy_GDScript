extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_money_change)
	MoneyManager.energy_import_cost_updated.connect(_on_money_change)
	MoneyManager.total_production_costs_updated.connect(_on_money_change)

	_on_money_change(0)
	

# Shows how much money the player will have next turn
func _on_money_change(_unused_signal_param):
	text = str(round(MoneyManager.get_money_for_next_turn()))
