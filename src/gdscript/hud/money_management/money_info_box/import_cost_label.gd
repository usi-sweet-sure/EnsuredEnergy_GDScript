extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_import_cost_updated.connect(_on_energy_import_cost_updated)
	_on_energy_import_cost_updated(Gameloop.energy_import_cost)

func _on_energy_import_cost_updated(new_value: float):
	if new_value != 0:
		show()
		text = "-" + str(round(new_value))
	else:
		hide()
