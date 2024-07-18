extends Sprite2D


func _ready():
	Gameloop.co2_emissions_updated.connect(_on_emissions_data_updated)
	Gameloop.imports_emissions_updated.connect(_on_emissions_data_updated)
	
	_on_emissions_data_updated(0)

func _on_emissions_data_updated(_percentage):
	# The arrow rotation percentage goes from -75% (full left) to 75% (full right)
	# No emission points the arrow at -75%
	# Emissions arent given in percentage but the max value is 100, so that's the same as if
	# they were
	# E. to be corrected if the max values don't go to 100 or the comput is different
	var co2_emissions_normalised = Gameloop.co2_emissions * 75 / 100.0
	var imports_emissions_normalised = Gameloop.imports_emissions * 75 / 100.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees",
			clamp(-75.0 + co2_emissions_normalised + imports_emissions_normalised, -75, 75), 0.5)
