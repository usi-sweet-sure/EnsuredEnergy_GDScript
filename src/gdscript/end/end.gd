extends CanvasLayer

signal metrics_leaderboard_updated
signal metrics_rank_updated


func _ready():
	Gameloop.game_ended.connect(_on_game_ended)
	Gameloop.show_ending_screen_requested.connect(_on_show_ending_screen)
	

func _on_game_ended():
	show()
	
	Context.get_rank()
	await Context.http.request_completed
	
	metrics_rank_updated.emit(Context.rank_json)
 
	Context.category = "5"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "7"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "9"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "11"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "13"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "15"
	Context.get_leaderboard()
	await Context.http.request_completed
	Context.category = "17"
	Context.get_leaderboard()
	await Context.http.request_completed
	
	metrics_leaderboard_updated.emit(Context.leaderboard_json)

	
	for power_plant in get_tree().get_nodes_in_group("PP"):
		power_plant._disable_with_no_effect()
	for build_button in get_tree().get_nodes_in_group("BB"):
		build_button._disable_for_end_of_game()
	
	
func _on_show_ending_screen():
	show()


func _on_close_button_pressed():
	hide()
