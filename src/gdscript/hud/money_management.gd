extends Control

@onready var money_info_box = $MoneyInfo/MoneyInfoBox
@onready var more_info_texts = [
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/BudgetText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/ProductionText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/BuildingText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/ImportText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/DebtText,
]


# Toggles information about money
func _on_money_info_button_pressed():
	money_info_box.visible = not money_info_box.visible


# Toggles more information about money
func _on_more_money_info_button_pressed():
	for text in more_info_texts:
		text.visible = not text.visible
	
	
# Hides the information box
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		money_info_box.hide()



