extends HSlider


func _on_toggle_borrow_money_frame_button_pressed():
	value = 0


func _on_borrow_money_apply_button_pressed():
	Gameloop.borrowed_money_amount += floor(value)
	value = 0
