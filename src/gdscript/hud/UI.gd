extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)

# If the player supplies enough energy in summer and winter, can go to the next turn
func _on_energy_supply_updated(value):
		$NextTurn.disabled = !Gameloop._check_supply()
		

func _on_next_turn_pressed():
	$TimePanelBlank._set_next_years_anim()
	$TimePanelBlank/TimelineAnimation.play("NextTurnAnim")
	# display shock after anim
	Gameloop.next_turn.emit()
	
	Gameloop.current_turn += 1
	Context1.yr = Gameloop.year_list[Gameloop.current_turn]


func _on_next_turn_gui_input(event):
	pass
	# add not enough energy warning
