extends Label


func _ready():
	Gameloop.co2_emissions_updated.connect(_on_co2_emissions_updated)
	_on_co2_emissions_updated(Gameloop.co2_emissions)
	
	
func _on_co2_emissions_updated(_value: float):
	text = str(Gameloop.co2_emissions).pad_decimals(1)
