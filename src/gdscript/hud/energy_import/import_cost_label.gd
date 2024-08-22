extends Label


func _ready():
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	text = str(floor(Gameloop.energy_import_cost))
	
	
func _on_imported_energy_amount_updated(_amount: int):
	text = str(floor(Gameloop.energy_import_cost))
