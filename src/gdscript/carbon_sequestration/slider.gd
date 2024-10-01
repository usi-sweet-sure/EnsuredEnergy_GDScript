extends HSlider

var previous_value = 0


func _ready():
	Gameloop.co2_emissions_updated.connect(_on_emissions_updated)
	Gameloop.next_turn.connect(_on_next_turn)


# Cannot sequestrate more than what is emitted
func _on_emissions_updated(emissions: float):
	if emissions != null:
		max_value = emissions

		
func _on_next_turn():
	previous_value = value


func _on_value_changed(value: float):
	Gameloop.sequestrated_co2 = value
	Gameloop.ups_list["774"] = value - previous_value
