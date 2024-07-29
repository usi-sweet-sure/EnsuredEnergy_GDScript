extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.building_costs_updated.connect(_on_building_cost_updated)


func _on_building_cost_updated(new_value):
	text = "-" + str(new_value)
