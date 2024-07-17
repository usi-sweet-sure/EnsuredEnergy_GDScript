extends Control

@onready var money_info_box = $MoneyInfo/MoneyInfoBox
@onready var more_info_texts = [
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/BudgetText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/ProductionText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/BuildingText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/ImportText,
	$MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/DebtText,
]

# Borrowed money nodes inside the borrow money frame
@onready var borrow_money_frame = $BorrowMoney/BorrowMoneyFrame
@onready var borrowed_amount_label = $BorrowMoney/BorrowMoneyFrame/Money/BorrowAmount
@onready var debt_amount_label = $BorrowMoney/BorrowMoneyFrame/Interest/InterestAmount
@onready var borrowed_money_slider = $BorrowMoney/BorrowMoneyFrame/BorrowSlider/Slider
# Borrowed money nodes inside the money information box
@onready var borrowed_money_info_box = $MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/Debt
@onready var borrowed_amount_label_in_info_box = $MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/Debt/borrowAmount
@onready var debt_amount_label_in_info_box = $MoneyInfo/MoneyInfoBox/MarginContainer/MarginContainer/VBoxContainer/Debt/debtAmount

@onready var money_info_opened_roll_sprite = $MoneyInfo/MoneyInfoBox/MarginContainer/InfoMoneyOpen
@onready var money_info_closed_rool_sprite = $MoneyInfo/MoneyInfoBox/MarginContainer/InfoMoneyClosed



func _ready():
	Gameloop.borrowed_money_amount_updated.connect(_on_borrowed_money_amount_updated)

# Updates the labels in the borrow money frame and the money info box
func _on_borrowed_money_amount_updated(borrowed_amount):
	var borrowed_amount_to_str = str(borrowed_amount)
	var debt_amount_to_str = str(borrowed_amount * (1.0 + (Gameloop.debt_percentage_on_borrowed_money / 100.0)))
	
	borrowed_amount_label.text = borrowed_amount_to_str
	debt_amount_label.text = debt_amount_to_str
	borrowed_amount_label_in_info_box.text = borrowed_amount_to_str
	debt_amount_label_in_info_box.text = "-" + debt_amount_to_str
	borrowed_money_info_box.visible = borrowed_amount > 0

# Toggles information about money
func _on_money_info_button_pressed():
	money_info_box.visible = not money_info_box.visible


# Toggles more information about money
func _on_more_money_info_button_pressed():
	for text in more_info_texts:
		text.visible = not text.visible
		money_info_opened_roll_sprite.visible = text.visible
		money_info_closed_rool_sprite.visible = not text.visible
	
	
# Hides different frames
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		money_info_box.hide()
		borrow_money_frame.hide()


# Shows the borrow money frame
func _on_borrow_money_button_pressed():
	borrow_money_frame.visible = not borrow_money_frame.visible


func _on_borrow_money_cancel_button_pressed():
	borrow_money_frame.hide();

# Moving the slider only updates the labels in the borrow money frame
func _on_borrow_money_slider_value_changed(value):
	borrowed_amount_label.text = str(value)
	debt_amount_label.text = str(value * (1.0 + (Gameloop.debt_percentage_on_borrowed_money / 100.0)))


# Will call 'self._on_borrowed_money_amount_updated' through the signal connected in 'self._ready'
func _on_borrow_money_apply_pressed():
	Gameloop.borrowed_money_amount = borrowed_money_slider.value
