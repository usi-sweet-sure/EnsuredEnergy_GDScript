extends Label


func _ready():
	Gameloop.biodiversity_updated.connect(_on_biodiversity_updated)
	_on_biodiversity_updated(Gameloop.biodiversity)
	
	
func _on_biodiversity_updated(value):
	text = str(value) + "%"
