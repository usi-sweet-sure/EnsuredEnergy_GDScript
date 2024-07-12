extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
	Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)

# If the player supplies enough energy in summer and winter, can go to the next turn
func _on_energy_supply_updated(value):
		$NextTurn.disabled = !Gameloop._check_supply()


# TODO polish anim
func _set_next_years_anim():
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	
	var last_decade = str(year)
	
	var anim = $TimePanelBlank/TimelineAnimation.get_animation("NextTurnAnim")
	var decade_anim = $TimePanelBlank/NextDecadeAP.get_animation("NextDecade")
	
	var anim_track = anim.find_track("Year:text", Animation.TYPE_VALUE)
	var arrow_track = anim.find_track("Arrow:rotation", Animation.TYPE_VALUE)
	var shadow_track = anim.find_track("Shadow:rotation", Animation.TYPE_VALUE)
	var year_track = anim.find_track("Year4:text", Animation.TYPE_VALUE)
	var year_track2 = anim.find_track("Year5:text", Animation.TYPE_VALUE)
	
	var n_keys = anim.track_get_key_count(anim_track)
	
	for i in n_keys:
		anim.track_set_key_value(anim_track, i, str(year + i))
		anim.track_set_key_value(arrow_track, i, remap(year+i, Gameloop.start_year, 2050, -2.18, 2.18))
		anim.track_set_key_value(shadow_track, i, remap(year+i, Gameloop.start_year, 2050, -2.22, 2.22))
		var year_num = str(year + i + 1)
		anim.track_set_key_value(year_track, i, str(year_num[3]))
		if (i < n_keys-1):
			var year_num2 = str(year + i + 1)
			anim.track_set_key_value(year_track2, i, str(year_num2[3]))
			if str(year_num2[3]) == "0":
				var decade_track = decade_anim.find_track("Year3:text", Animation.TYPE_VALUE)
				var decade_track2 = decade_anim.find_track("Year6:text", Animation.TYPE_VALUE)
				decade_anim.track_set_key_value(decade_track, 0, str(last_decade[2]))
				decade_anim.track_set_key_value(decade_track2, 0, str(year_num2[2]))
				$TimePanelBlank/NextDecadeAP.play("NextDecade")
		

func _on_next_turn_pressed():
	_set_next_years_anim()
	$TimePanelBlank/TimelineAnimation.play("NextTurnAnim")
	# display shock after anim
	Gameloop.next_turn.emit()
	
	Gameloop.current_turn += 1
	Context1.yr = Gameloop.year_list[Gameloop.current_turn]


func _on_next_turn_gui_input(event):
	pass
	# add not enough energy warning
