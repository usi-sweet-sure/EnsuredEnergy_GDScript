extends Label


func _on_borrow_money_slider_value_changed(value: float):
	text = str(value)
	
	if value != 0:
		text += "M CHF"
