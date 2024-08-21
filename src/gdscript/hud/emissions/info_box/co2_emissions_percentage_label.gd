extends Label


func _ready():
	Gameloop.co2_emissions_updated.connect(_on_co2_emissions_updated)
	_on_co2_emissions_updated(Gameloop.co2_emissions)
	
	
func _on_co2_emissions_updated(value: float):
	text = str(value).pad_decimals(1)
