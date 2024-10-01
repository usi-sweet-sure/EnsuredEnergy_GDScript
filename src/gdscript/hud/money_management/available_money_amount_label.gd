extends Label


func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_available_money_amount_updated)
	_on_available_money_amount_updated(MoneyManager.available_money_amount)


func _on_available_money_amount_updated(amount: float):
	text = str(round(amount))
