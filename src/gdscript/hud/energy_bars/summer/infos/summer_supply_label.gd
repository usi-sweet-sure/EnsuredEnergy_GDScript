extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_summer.connect(_on_summer_energy_supply_updated)
	_on_summer_energy_supply_updated(Gameloop.supply_summer)
	
	
func _on_summer_energy_supply_updated(value: float):
	text = str(round(value))
