extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.available_money_amount_updated.connect(_on_available_money_amount_updated)
	_on_available_money_amount_updated(Gameloop.available_money_amount)
	

func _on_available_money_amount_updated(value: float):
	text = str(round(value))
