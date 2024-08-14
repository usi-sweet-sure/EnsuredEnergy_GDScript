extends Label


func _ready():
	Gameloop.biodiversity_percentage_updated.connect(_on_biodiversity_percentage_updated)
	_on_biodiversity_percentage_updated(Gameloop.biodiversity_percentage)
	
	
func _on_biodiversity_percentage_updated(value):
	text = str(value) + "%"
