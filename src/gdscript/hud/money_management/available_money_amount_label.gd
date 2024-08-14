extends Label


func _ready():
	Gameloop.available_money_amount_updated.connect(_on_available_money_amount_updated)
	_on_available_money_amount_updated(Gameloop.available_money_amount)


func _on_available_money_amount_updated(amount):
	text = str(round(amount))
