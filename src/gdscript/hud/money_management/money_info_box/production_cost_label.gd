extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.powerplants_production_costs_updated.connect(_on_powerplants_production_costs_updated)


func _on_powerplants_production_costs_updated(new_value: float):
	text = "-" + str(round(new_value))
