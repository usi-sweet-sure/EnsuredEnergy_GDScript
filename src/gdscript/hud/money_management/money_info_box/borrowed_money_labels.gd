extends Label

@onready var borrowed_amount_label = $"../BorrowedAmount"
@onready var debt_amount_label = $"../DebtAmount"


func _ready():
	MoneyManager.borrowed_money_amount_updated.connect(_on_borrowed_money_amount_updated)


func _on_borrowed_money_amount_updated(borrowed_amount: float):
	borrowed_amount_label.text = str(round(borrowed_amount)).pad_decimals(0)
	debt_amount_label.text = "-" + str(round(borrowed_amount * (1.0 + (MoneyManager.debt_percentage_on_borrowed_money / 100.0)))).pad_decimals(0)
	borrowed_amount_label.visible = borrowed_amount > 0
	debt_amount_label.visible = borrowed_amount > 0
