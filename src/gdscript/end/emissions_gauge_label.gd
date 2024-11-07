extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.co2_emissions_updated.connect(_on_co2_emissions_updated)
	_on_co2_emissions_updated(Gameloop.co2_emissions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_co2_emissions_updated(val: float):
	text = str(val).pad_decimals(2)
