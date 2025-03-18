extends Label


func _on_borrow_money_slider_value_changed(value: float):
	text = str(value).pad_decimals(0)
	
	if value != 0:
		text += "M CHF"
