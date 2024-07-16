extends VSlider

@onready var clean_import_led: Sprite2D = $LEDOn
@onready var import_slider: VSlider = $"."
@onready var imported_energy_cost_label: Label = $"../ImportEnergy-bar-metal/ImportCosts"

# Keeps track of the previous amount imported so we can remove it from the supply before adding the new one
var previous_import: int = 0
# We use this condition to block listening to energy supply updates while we are importing energy so
# to not trigger side effects. We listen to supply updates to lower the amount of energy imported
# if others sources supply enoough energy
var energy_supply_updated_by_imports := false


func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated_winter)
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated_winter)
	Gameloop.energy_import_cost_updated.connect(_on_energy_import_cost_updated)
	Gameloop.green_energy_import_on_updated.connect(_on_green_energy_import_on_updated)
	
	# We have to do this to initialize the bar since it is created after the demand
	# has been set for the first time in Gameloop
	_on_energy_demand_updated_winter(Gameloop.demand_winter)
	_on_energy_import_cost_updated(Gameloop.energy_import_cost)


# Connected to the import slider 'value_changed' signal.
# Makes sure the user does not import more energy than needed
func _on_import_slider_value_changed(new_value: float):
	# We don't want to trigger our own listeners
	energy_supply_updated_by_imports = true
	# Can be negative if the user lowered the import. Will be added to Gameloop.supply_winter
	var add_to_winter_supply = value - previous_import
	
	# Prevents the user from importing more than the energy demand
	if(Gameloop.supply_winter + add_to_winter_supply > Gameloop.demand_winter):
		set_value_no_signal(Gameloop.demand_winter - Gameloop.supply_winter + previous_import)
		add_to_winter_supply = Gameloop.demand_winter - Gameloop.supply_winter

	previous_import = value
	Gameloop.supply_winter += add_to_winter_supply
	
	# E. This is clearly not what to do, it's missing the right formula for the price
	Gameloop.energy_import_cost = round(value * 0.01)
	
	# We can listen again to updates to Gameloop.winter_supply
	energy_supply_updated_by_imports = false


# We reduce the energy supplied by imports if other sources supply enough energy
func _on_energy_supply_updated_winter(winter_supply):
	var energy_supply_excess = winter_supply - Gameloop.demand_winter
	if not energy_supply_updated_by_imports and energy_supply_excess > 0 :
		# This will call _on_import_slider_value_changed, which takes care of updating the supply
		# the same way as if the user updated himself the import
		value = max(0, previous_import - energy_supply_excess)
		
		
func _on_energy_import_cost_updated(cost: int):
	imported_energy_cost_label.text = str(cost)


func _on_green_energy_import_on_updated(green_energy_import_on: bool):
	_on_energy_import_cost_updated(Gameloop.energy_import_cost)
		

func _on_import_up_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value += import_slider.step


func _on_import_down_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value -= import_slider.step


func _on_clean_import_switch_toggled(toggled_on):
	clean_import_led.visible = toggled_on
	# This will trigger a signal which will call _on_green_energy_import_on_updated
	Gameloop.green_energy_import_on = toggled_on 


# Updates properties of the slider so we don't have to update the node manually
func _on_energy_demand_updated_winter(demand):
	max_value = demand
	step = round(demand / size.x)
