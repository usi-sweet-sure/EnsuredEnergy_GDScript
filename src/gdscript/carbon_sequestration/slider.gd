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


func _on_value_changed(value_: float):
	Gameloop.sequestrated_co2 = value_
	Gameloop.ups_list["774"] = value_ - previous_value
	MoneyManager.carbon_sequestration_production_costs = value_ * 10


func _on_drag_ended(value_changed_):
	if value_changed_:
		Gameloop.available_money_message_requested.emit("-" + str(value * 10).pad_decimals(2) + "M CHF", false)
