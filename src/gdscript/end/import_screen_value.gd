extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	_on_imported_energy_amount_updated(Gameloop.imported_energy_amount)


func _on_imported_energy_amount_updated(val: float):
	var import_percentage = val / Gameloop.supply_winter * 100
	text = str(import_percentage).pad_decimals(2) + " %"
