extends Node2D

var previous_value = 0

func _ready():
	Gameloop.co2_emissions_updated.connect(_on_emissions_updated)
	Gameloop.next_turn.connect(_on_next_turn)

# Cannot sequestre more than what is emitted
func _on_emissions_updated(emissions):
	if emissions != null:
		%CarbonSlider.max_value = emissions

# Shows how much CO2 seq costs per 
func _on_carbon_slider_value_changed(value):
	if value == 0:
		$BuildInfo/ColorRect/ContainerN/Poll.text = str(value) + "M CO2/t"
		$BuildInfo/ColorRect/ContainerN/Prod.text = str(value * 10) + "M CHF"
	else:
		$BuildInfo/ColorRect/ContainerN/Poll.text = str(-value).pad_decimals(2) + "M CO2/t"
		$BuildInfo/ColorRect/ContainerN/Prod.text = str(-value * 10).pad_decimals(2) + "M CHF"

func _on_carbon_slider_drag_ended(value_changed):
	if value_changed:
		Gameloop.sequestrated_co2 = %CarbonSlider.value
		Gameloop.ups_list["774"] = %CarbonSlider.value - previous_value
	
func _on_next_turn():
	previous_value = %CarbonSlider.value
