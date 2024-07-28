extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.next_turn.connect(_on_next_turn)


func _on_next_turn_button_pressed():
	hide()


func _on_next_turn():
	var all_power_plants = get_tree().get_nodes_in_group("PP")
	for power_plant in all_power_plants:
		if power_plant.is_alive and power_plant.is_nuclear():
			print(power_plant.life_span, " - ",Gameloop.current_turn)
			if Gameloop.current_turn + 1 >= power_plant.life_span:
				show()
