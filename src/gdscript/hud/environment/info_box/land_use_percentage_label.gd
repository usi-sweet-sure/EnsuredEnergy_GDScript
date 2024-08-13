extends Label


func _ready():
	Gameloop.land_use_updated.connect(_on_land_use_updated)
	_on_land_use_updated(Gameloop.land_use)
	
	
func _on_land_use_updated(value):
	text = str(value) + "%"
