extends VSlider

var value_before_tutorial = 0

func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated_winter)
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated_winter)
	Gameloop.game_ended.connect(_on_game_ended)
	Gameloop.next_turn.connect(_on_next_turn)
	TutorialManager.tutorial_started.connect(func(): value_before_tutorial = Gameloop.imported_energy_amount)
	TutorialManager.tutorial_ended.connect(func(): value = value_before_tutorial)
	
	_on_energy_demand_updated_winter(Gameloop.demand_winter)


# Makes sure the user does not import more energy than needed
func _on_import_slider_value_changed(_new_value: float):
	var new_imported_amount = value
	
	# Prevents the user from importing more than the energy demand
	if(Gameloop.supply_winter + new_imported_amount > Gameloop.demand_winter):
		new_imported_amount = max(0, Gameloop.demand_winter - Gameloop.supply_winter)
		set_value_no_signal(new_imported_amount)

	Gameloop.imported_energy_amount = new_imported_amount


func _on_energy_supply_updated_winter(winter_supply: float):
	_update_slider_properties()
	
	# We reduce the energy supplied by imports if other sources supply enough energy
	var energy_supply_excess = winter_supply + Gameloop.imported_energy_amount - Gameloop.demand_winter
	if energy_supply_excess > 0 :
		# This will call _on_import_slider_value_changed, which takes care of updating the
		# imported amount the same way as if the user used the slider
		value = max(0, Gameloop.demand_winter - winter_supply)


func _on_import_up_button_pressed():
	value += step


func _on_import_down_button_pressed():
	value -= step


func _on_energy_demand_updated_winter(demand: float):
	_update_slider_properties()


# Updates the slider properties when the winter demand or supply change
func _update_slider_properties():
	# The player can't import more than needed
	var max_amount_that_can_be_imported = Gameloop.demand_winter - Gameloop.supply_winter
	var previous_value = Gameloop.imported_energy_amount
	# Step must not update, otherwise the value will be changed too when
	# properties update to adapt to the new step
	step = 0.5
	# We must add the step, otherwise the user may not always be able to
	# move the slider all the way up if the last step would go higher than the
	# max than can be imported
	max_value = max_amount_that_can_be_imported + step
	

func _on_game_ended():
	editable = false


# Moves the slider to the bottom. Doesn't send the signal because the value
# is already set back to zero in "gameloop.gd" on a new turn
func _on_next_turn():
	set_value_no_signal(0)


func _on_drag_ended(value_changed):
	TutorialManager.next_step_requested.emit()
