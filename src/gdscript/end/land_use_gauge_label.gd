extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.land_use_updated.connect(_on_land_use_updated)
	_on_land_use_updated(Gameloop.land_use)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_land_use_updated(val: float):
	text = str(val).pad_decimals(2)
