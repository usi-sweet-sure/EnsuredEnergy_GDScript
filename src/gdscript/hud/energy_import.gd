extends VSlider

@onready var clean_import_led: Sprite2D = $LEDOn
@onready var import_slider: VSlider = $"."
@onready var imported_energy_cost_label: Label = $"../ImportEnergy-bar-metal/ImportCosts"

# Keeps track of the previous amount imported so we can remove it from the supply before adding the new one
var previous_import: int = 0

func _ready():
	Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated_winter)
	_on_energy_demand_updated_winter(Gameloop.demand_winter)

func update_imported_energy_cost_label(cost: String):
	imported_energy_cost_label.text = cost


# Connected to the import slider 'value_changed' signal
func _on_import_slider_value_changed(new_value: float):
	pass
	
	
func _on_import_up_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value += import_slider.step


func _on_import_down_button_pressed():
	# Triggers the import slider 'v'alue_changed' signal
	import_slider.value -= import_slider.step


func _on_clean_import_switch_toggled(toggled_on):
	clean_import_led.visible = toggled_on

# Updates the max value allowed by the slider so we don't have to update the node manually
func _on_energy_demand_updated_winter(demand):
	max_value = demand


func _on_import_slider_drag_ended(value_changed):
	if(value_changed):
		var add_to_supply = value - previous_import # Can be negative if the user lowered the import
		
		# Prevents the user from exceding the energy demand
		if(Gameloop.supply_winter + add_to_supply > Gameloop.demand_winter):
			set_value_no_signal(Gameloop.demand_winter - Gameloop.supply_winter + previous_import)

		previous_import = value
		Gameloop.supply_winter += add_to_supply

		# E. This is clearly not what to do, it's just to have a visual feedback
		update_imported_energy_cost_label(str(value))
