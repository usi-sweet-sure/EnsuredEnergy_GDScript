extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_available_money_updated)


func _on_available_money_updated(val: float):
	text = str(val).pad_decimals(2) + "M"
