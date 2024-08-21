extends Label


func _ready():
	Gameloop.imports_emissions_updated.connect(_on_imports_emissions_updated)
	_on_imports_emissions_updated(Gameloop.imports_emissions)
	
	
func _on_imports_emissions_updated(value):
	text = str(value).pad_decimals(1)
