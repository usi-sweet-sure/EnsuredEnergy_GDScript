extends Label


func _ready():
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	Gameloop.green_energy_import_on_updated.connect(_on_green_energy_import_on_updated)
	
	text = str(Gameloop.energy_import_cost)
	
	
func _on_imported_energy_amount_updated(_amount: int):
	text = str(Gameloop.energy_import_cost)

func _on_green_energy_import_on_updated(_toggled_on: bool):
	text = str(Gameloop.energy_import_cost)
