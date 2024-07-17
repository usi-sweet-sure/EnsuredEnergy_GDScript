extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)
	Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)

# If the player supplies enough energy in summer and winter, can go to the next turn
func _on_energy_supply_updated(value):
	$NextTurn.disabled = !Gameloop._check_supply()

func _on_imported_energy_amount_updated(value):
	$NextTurn.disabled = !Gameloop._check_supply()
	
func _on_next_turn_pressed():
	$TimePanelBlank._set_next_years_anim()
	$TimePanelBlank/TimelineAnimation.play("NextTurnAnim")
	await $TimePanelBlank/TimelineAnimation.animation_finished
	# display shock after anim
	
	if Gameloop.current_turn == Gameloop.n_turns:
		Gameloop.end.emit()
		$NextTurn.hide()
	else:
		Gameloop.next_turn.emit()
		Gameloop.current_turn += 1
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
	
	
func _on_next_turn_gui_input(event):
	pass
	# add not enough energy warning
