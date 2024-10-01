extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.players_own_money_amount_updated.connect(_on_money_change)
	MoneyManager.borrowed_money_amount_updated.connect(_on_money_change)
	_on_money_change(0)


func _on_money_change(_value: float):
	text = str(round(MoneyManager.players_own_money_amount + MoneyManager.borrowed_money_amount))
