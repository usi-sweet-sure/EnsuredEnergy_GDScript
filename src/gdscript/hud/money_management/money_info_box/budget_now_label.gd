extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.available_money_amount_updated.connect(_on_available_money_updated)
	_on_available_money_updated(Gameloop.players_own_money_amount)


func _on_available_money_updated(value: int):
	text = str(value)
