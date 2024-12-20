extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
	_on_imported_energy_amount_updated(Gameloop.imported_energy_amount)


func _on_imported_energy_amount_updated(value: float):
	text = str(value).pad_decimals(0)
