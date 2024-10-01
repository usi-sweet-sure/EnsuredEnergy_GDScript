extends Label


func _on_slider_value_changed(value: float):
	if value == 0:
		text = str(value * 10) + "M CHF"
	else:
		text = str(value * 10).pad_decimals(2) + "M CHF"
