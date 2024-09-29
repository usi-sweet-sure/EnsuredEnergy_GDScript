extends Label

var upgrade_cost := 0.0


func _ready():
	hide()


func _on_metrics_updated(metrics: PowerplantMetrics):
	upgrade_cost = metrics.upgrade_cost

	
func _change_text_to_green():
	set("theme_override_colors/font_color", Color(0,0.882,0))
	

func _change_text_to_red():
	set("theme_override_colors/font_color", Color(1.0, 0.129, 0.208))


func _on_button_plus_mouse_entered():
	text = "-" + str(upgrade_cost).pad_decimals(0) + "M CHF"
	_change_text_to_red()


func _on_button_minus_mouse_entered():
	text = "+" + str(upgrade_cost).pad_decimals(0) + "M CHF"
	_change_text_to_green()
