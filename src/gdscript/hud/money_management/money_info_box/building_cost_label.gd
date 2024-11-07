extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.building_costs_updated.connect(_on_building_cost_updated)
	_on_building_cost_updated(MoneyManager.building_costs)

func _on_building_cost_updated(new_value: float):
	if new_value != 0:
		show()
		text = "-" + str(round(new_value))
	else:
		hide()
