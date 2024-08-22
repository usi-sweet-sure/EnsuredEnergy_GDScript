extends VSlider


func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated_winter)
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated_winter)
	
	_on_energy_demand_updated_winter(Gameloop.demand_winter)


# Makes sure the user does not import more energy than needed
func _on_import_slider_value_changed(_new_value: float):
	var new_imported_amount = value
	
	# Prevents the user from importing more than the energy demand
	if(Gameloop.supply_winter + new_imported_amount > Gameloop.demand_winter):
		new_imported_amount = max(0, Gameloop.demand_winter - Gameloop.supply_winter)
		set_value_no_signal(new_imported_amount)

	Gameloop.imported_energy_amount = new_imported_amount


# We reduce the energy supplied by imports if other sources supply enough energy
func _on_energy_supply_updated_winter(winter_supply: float):
	var energy_supply_excess = winter_supply + Gameloop.imported_energy_amount - Gameloop.demand_winter
	if energy_supply_excess > 0 :
		# This will call _on_import_slider_value_changed, which takes care of updating the
		# imported amount the same way as if the user used the slider
		value = max(0, Gameloop.demand_winter - winter_supply)

func _on_import_up_button_pressed():
	value += step


func _on_import_down_button_pressed():
	value -= step


# Updates properties of the slider so we don't have to update the node manually
func _on_energy_demand_updated_winter(demand: float):
	# S. I want the player to feel like they are importing a lot
	# E. I removed the / 4. But I get you, we need to find a way, this is just for
	# the temporary version we have to send out
	max_value = demand / 2
	#step = round(demand / size.x)
