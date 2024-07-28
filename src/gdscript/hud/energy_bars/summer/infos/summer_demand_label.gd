extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_demand_updated_summer.connect(_on_summer_energy_demand_updated)
	_on_summer_energy_demand_updated(Gameloop.demand_summer)
	
	
func _on_summer_energy_demand_updated(value: float):
	text = str(round(value))
