extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.building_costs_updated.connect(_on_building_cost_updated)
	_on_building_cost_updated(MoneyManager.building_costs)

func _on_building_cost_updated(new_value: float):
	if new_value != 0:
		set_self_modulate(Color("ffffff"))
		text = "-" + str(round(new_value)).pad_decimals(0)
	else:
		set_self_modulate(Color("ffffff00"))
