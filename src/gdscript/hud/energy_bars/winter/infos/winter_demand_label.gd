extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_winter_energy_demand_updated)
	_on_winter_energy_demand_updated(Gameloop.demand_winter)
	
	
func _on_winter_energy_demand_updated(value: float):
	text = str(round(value))
