extends VSlider

@onready var clean_import_led: Sprite2D = $LEDOn
@onready var import_slider: VSlider = $"."
@onready var imported_energy_cost_label: Label = $"../ImportEnergy-bar-metal/ImportCosts"

# Keeps track of the previous amount imported so we can remove it from the supply before adding the new one
var previous_import: int = 0
# We use this condition to block listening to energy supply updates while we are importing energy
# to not trigger side effects. We listen to supply updates to lower the amount of energy imported
# if others sources supply enoough energy
var energy_supply_updated_by_imports := false

func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated_winter)
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated_winter)
	_on_energy_demand_updated_winter(Gameloop.demand_winter)


# Connected to the import slider 'value_changed' signal
func _on_import_slider_value_changed(new_value: float):
	energy_supply_updated_by_imports = true
	# Can be negative if the user lowered the import
	var add_to_supply = value - previous_import
	
	# Prevents the user from importing more than the energy demand
	if(Gameloop.supply_winter + add_to_supply > Gameloop.demand_winter):
		set_value_no_signal(Gameloop.demand_winter - Gameloop.supply_winter + previous_import)
		add_to_supply = Gameloop.demand_winter - Gameloop.supply_winter

	previous_import = value
	Gameloop.supply_winter += add_to_supply
	

	# E. This is clearly not what to do, it's just to have a visual feedback
	update_imported_energy_cost_label(str(value))
	energy_supply_updated_by_imports = false

# We reduce the energy supplied by imports if other sources supply enough energy
func _on_energy_supply_updated_winter(winter_supply):
	var energy_supply_excess = winter_supply - Gameloop.demand_winter
	if not energy_supply_updated_by_imports and energy_supply_excess > 0 :
		# This will call _on_import_slider_value_changed, which takes care of updating the supply
		# the same way as if the user updated himself the import
		value = max(0, previous_import - energy_supply_excess)
		

func _on_import_up_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value += import_slider.step


func _on_import_down_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value -= import_slider.step


func _on_clean_import_switch_toggled(toggled_on):
	clean_import_led.visible = toggled_on

# Updates properties of the slider so we don't have to update the node manually
func _on_energy_demand_updated_winter(demand):
	max_value = demand
	step = round(demand / size.x)
	
	
func update_imported_energy_cost_label(cost: String):
	imported_energy_cost_label.text = cost
