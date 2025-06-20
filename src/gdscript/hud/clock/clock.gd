extends Node

@onready var timeline_animation: AnimationPlayer = $TimelineAnimation
@onready var ring_animation = $Ring


func _ready():
	ShockManager.shock_effects_applied.connect(_on_shock_effect_applied)
	

func _set_next_years_anim():
	var year = Gameloop.year_list[Gameloop.current_turn-1]
	
	var last_decade = str(year)
	
	var anim = timeline_animation.get_animation("go_to_center")
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

		
func _on_next_turn_button_pressed():
	PowerplantsManager.unfocus_all.emit()
	InfoFramesManager.hide_frame_requested.emit(InfoFramesManager.current_frame)
	# This signal allows for some ui elements and other systems to "turn off"
	# while the next turn is being set to not trigger side effects
	Gameloop.next_turn_button_pressed.emit()

	_set_next_years_anim()
	timeline_animation.play("go_to_center")
	ring_animation.play("rotate_ring")
	
	if Gameloop.current_turn == Gameloop.total_number_of_turns:
		CameraManager.reset_camera.emit()
		await timeline_animation.animation_finished
		ring_animation.stop()
		timeline_animation.play("clock_disappears")
		var timer = get_tree().create_timer(3.6)
		await timer.timeout
		Gameloop.game_ended.emit()
	else:
		await timeline_animation.animation_finished
		Gameloop.current_turn += 1
		Gameloop.next_turn.emit()


func _on_shock_effect_applied(_shock):
	if timeline_animation.is_playing():
		await  timeline_animation.animation_finished
		
	ring_animation.play("rotate_ring_backward")
	timeline_animation.play("go_back_to_corner")
	await timeline_animation.animation_finished
	ring_animation.stop()
	Gameloop.player_can_start_playing_new_turn.emit()
