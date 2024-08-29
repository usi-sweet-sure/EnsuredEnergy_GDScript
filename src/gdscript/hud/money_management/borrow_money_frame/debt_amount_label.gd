extends Label


func _on_borrow_money_slider_value_changed(value: float):
	text = str(value * (1.0 + (Gameloop.debt_percentage_on_borrowed_money / 100.0)))
	
	if value != 0:
		text += "M CHF"
