extends Label

var delta := 0.0


func _ready():
	hide()


func _on_metrics_updated(metrics: PowerplantMetrics):
	var base_metrics = PowerplantsManager.powerplants_metrics[metrics.type]
	delta = base_metrics.availability.y * base_metrics.capacity * metrics.upgrade_factor_for_winter_supply

	
func _change_text_to_green():
	set("theme_override_colors/font_color", Color(0,0.882,0))
	

func _change_text_to_red():
	set("theme_override_colors/font_color", Color(1.0, 0.129, 0.208))


func _on_button_plus_mouse_entered():
	if delta == 0:
		text = ""
	elif delta <= 0:
		text = str(delta).pad_decimals(2)
		_change_text_to_red()
	else:
		text = "+" + str(delta).pad_decimals(2)
		_change_text_to_green()


func _on_button_minus_mouse_entered():
	if delta == 0:
		text = ""
	elif delta <= 0:
		text = "+" + str(abs(delta)).pad_decimals(2)
		_change_text_to_green()
	else:
		text = "-" + str(delta).pad_decimals(2)
		_change_text_to_red()
