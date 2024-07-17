extends Label

@onready var borrowed_amount_label = $BorrowedAmount
@onready var debt_amount_label = $DebtAmount


func _ready():
	Gameloop.borrowed_money_amount_updated.connect(_on_borrowed_money_amount_updated)


func _on_borrowed_money_amount_updated(borrowed_amount):
	borrowed_amount_label.text = str(borrowed_amount)
	debt_amount_label.text = "-" + str(borrowed_amount * (1.0 + (Gameloop.debt_percentage_on_borrowed_money / 100.0)))
	visible = borrowed_amount > 0
