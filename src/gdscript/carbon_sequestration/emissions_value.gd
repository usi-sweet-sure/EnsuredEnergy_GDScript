extends Label


func _on_slider_value_changed(value: float):
	if value == 0:
		text = str(value) + "M CO2/t"
	else:
		text = str(-value).pad_decimals(2) + "M CO2/t"
