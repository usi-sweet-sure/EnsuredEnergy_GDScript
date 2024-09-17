extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_winter_energy_supply_updated)
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	_on_imported_energy_amount_updated(Gameloop.imported_energy_amount)
	
	
func _on_winter_energy_supply_updated(value: float):
	text = str(round(value + Gameloop.imported_energy_amount))


func _on_imported_energy_amount_updated(value: float):
	text = str(round(value + Gameloop.supply_winter))
