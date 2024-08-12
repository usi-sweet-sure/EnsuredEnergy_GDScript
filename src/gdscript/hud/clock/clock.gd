extends Node

@onready var clock_info_sticker = $TurnInfoContainer


func _set_next_years_anim():
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	
	var last_decade = str(year)
	
	var anim = $TimelineAnimation.get_animation("NextTurnAnim")
	var decade_anim = $NextDecadeAP.get_animation("NextDecade")
	
	#var anim_track = anim.find_track("Year:text", Animation.TYPE_VALUE)
	var arrow_track = anim.find_track("Arrow:rotation", Animation.TYPE_VALUE)
	var shadow_track = anim.find_track("Shadow:rotation", Animation.TYPE_VALUE)
	var year_track = anim.find_track("Year4:text", Animation.TYPE_VALUE)
	var year_track2 = anim.find_track("Year5:text", Animation.TYPE_VALUE)
	
	var n_keys = 4
	
	for i in n_keys:
		#anim.track_set_key_value(anim_track, i, str(year + i))
		anim.track_set_key_value(arrow_track, i, remap(year+i, Gameloop.start_year, 2052, -2.18, 2.18))
		anim.track_set_key_value(shadow_track, i, remap(year+i, Gameloop.start_year, 2052, -2.22, 2.22))
		var year_num = str(year + i)
		anim.track_set_key_value(year_track, i, str(year_num[3]))
		if (i < n_keys-1):
			var year_num2 = str(year + i + 1)
			anim.track_set_key_value(year_track2, i, str(year_num2[3]))
			if str(year_num2[3]) == "0":
				var decade_track = decade_anim.find_track("Year3:text", Animation.TYPE_VALUE)
				var decade_track2 = decade_anim.find_track("Year6:text", Animation.TYPE_VALUE)
				decade_anim.track_set_key_value(decade_track, 0, str(last_decade[2]))
				decade_anim.track_set_key_value(decade_track2, 0, str(year_num2[2]))
				$NextDecadeAP.play("NextDecade")

func clock_pressed():
	clock_info_sticker.visible = not clock_info_sticker.visible


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		clock_info_sticker.hide()
		
		
func _on_next_turn_button_pressed():
	_set_next_years_anim()
	$TimelineAnimation.play("NextTurnAnim")
	await $TimelineAnimation.animation_finished
	ShockManager.pick_shock()
	ShockManager.apply_shock()
	
	if Gameloop.current_turn == Gameloop.total_number_of_turns:
		Gameloop.end.emit()
		$"../../NextTurn".hide()
	else:
		Gameloop.current_turn += 1
		Gameloop.next_turn.emit()
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		
	Gameloop.set_money_for_new_turn()
	
