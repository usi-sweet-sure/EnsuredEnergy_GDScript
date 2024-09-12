extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.sequestrated_co2_updated.connect(_on_sequestrated_co2_updated)
	_on_sequestrated_co2_updated(Gameloop.sequestrated_co2)
	

func _on_sequestrated_co2_updated(value: float):
	text = str(value).pad_decimals(1)
