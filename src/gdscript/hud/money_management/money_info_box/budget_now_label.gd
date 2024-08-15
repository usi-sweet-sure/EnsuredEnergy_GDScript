extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.players_own_money_amount_updated.connect(_on_money_change)
	Gameloop.borrowed_money_amount_updated.connect(_on_money_change)
	_on_money_change(0)


func _on_money_change(_value: float):
	text = str(round(Gameloop.players_own_money_amount + Gameloop.borrowed_money_amount))
