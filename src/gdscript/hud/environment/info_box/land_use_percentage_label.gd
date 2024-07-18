extends Label


func _ready():
	Gameloop.land_use_percentage_updated.connect(_on_land_use_percentage_updated)
	_on_land_use_percentage_updated(Gameloop.land_use_percentage)
	
	
func _on_land_use_percentage_updated(value):
	text = str(value) + "%"
