extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_import_cost_updated.connect(_on_energy_import_cost_updated)


func _on_energy_import_cost_updated(new_value: float):
	text = "-" + str(round(new_value))
