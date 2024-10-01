extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_available_money_amount_updated)
	_on_available_money_amount_updated(MoneyManager.available_money_amount)
	

func _on_available_money_amount_updated(value: float):
	text = str(round(value))
