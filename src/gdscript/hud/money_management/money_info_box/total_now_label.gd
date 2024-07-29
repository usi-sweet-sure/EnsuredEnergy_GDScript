extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.available_money_amount_updated.connect(_on_money_change)
	Gameloop.building_costs_updated.connect(_on_money_change)
	
	_on_money_change(0)
	

func _on_money_change(_unused_signal_param):
	text = str(round(Gameloop.available_money_amount - Gameloop.building_costs))
