extends CanvasLayer

signal metrics_leaderboard_updated
signal metrics_rank_updated

@export var tick_icon: Texture2D
@export var pen_icon: Texture2D

func _ready():
	Gameloop.game_ended.connect(_on_game_ended)
	Gameloop.show_ending_screen_requested.connect(_on_show_ending_screen)
	%player_name.placeholder_text = tr("PLAYER_NAME_PLACEHOLDER")
	Context.player_name_changed.connect(_on_player_name_changed)


func _on_game_ended():
	show()
	
	Context.get_rank(Context.res_id)
	await Context.rank_updated
	
	metrics_rank_updated.emit(Context.rank_json)
 
	Context.get_leaderboard_from_model("5")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("7")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("9")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("11")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("13")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("15")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("17")
	await Context.leaderboard_updated
	
	metrics_leaderboard_updated.emit(Context.leaderboard_json)
	
	
func _on_show_ending_screen():
	show()


func _on_close_button_pressed():
	hide()


func _on_player_name_text_submitted(new_text):
	#Gameloop.player_name = new_text
	if new_text == "" or new_text == null:
		new_text = "new_player"
		%player_name.text = new_text
	Context.change_player_name(Context.res_id, new_text.uri_encode())
	%player_name.editable = false
	%NameEdit.hide()
	%player_name.release_focus()
	%NameEdit.button_pressed = false
	
	
func _on_player_name_changed():
	%player_name.editable = true
	%NameEdit.show()


func _on_name_edit_toggled(toggled_on):
	if toggled_on:
		%NameEdit.icon = tick_icon
		%player_name.grab_focus()
	else:
		%NameEdit.icon = pen_icon
		if %player_name.editable:
			%player_name.text_submitted.emit(%player_name.text)
			%player_name.release_focus()


func _on_player_name_focus_entered():
	%NameEdit.set_pressed_no_signal(true)
	%NameEdit.icon = tick_icon


func _on_player_name_focus_exited():
	%NameEdit.toggled.emit(false)


func _on_button_pressed():
	%NameInfoButton.hide()
	%player_name.grab_focus()
