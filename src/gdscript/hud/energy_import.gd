extends Node

@onready var clean_import_led: Sprite2D = $LEDOn
@onready var import_slider: VSlider = $"."
@onready var imported_energy_cost_label: Label = $"../ImportEnergy-bar-metal/ImportCosts"


func update_imported_energy_cost_label(cost: String):
	imported_energy_cost_label.text = cost


# Connected to the import slider 'value_changed' signal
# E. If a request is done to the API when the value changes, the 'value_changed'
# 	signal may not be the best since it's called very often during the slide, in that case
# 	'drag_ended' signal may be more suitable
func _on_import_slider_value_changed(value):
	# E. The value should be ceiled to not exceed the amount of energy needed
	
	# E. This is clearly not what to do, it's just to have a visual feedback
	update_imported_energy_cost_label(str(value))
	
	
func _on_import_up_button_pressed():
	# Triggers the import slider 'value_changed' signal
	import_slider.value += import_slider.step


func _on_import_down_button_pressed():
	# Triggers the import slider 'v'alue_changed' signal
	import_slider.value -= import_slider.step


func _on_clean_import_switch_toggled(toggled_on):
	clean_import_led.visible = toggled_on
