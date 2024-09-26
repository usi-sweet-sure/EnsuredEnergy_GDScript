extends CanvasLayer

signal metrics_leaderboard_updated
signal metrics_rank_updated

func _ready():
	Gameloop.game_ended.connect(_on_game_ended)
	Gameloop.show_ending_screen_requested.connect(_on_show_ending_screen)
	

func _on_game_ended():
	show()
	
	Context1.get_rank()
	await Context1.http1.request_completed
	
	metrics_rank_updated.emit(Context1.rank_json)
 
	Context1.category = "5"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "7"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "9"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "11"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "13"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "15"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	Context1.category = "17"
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	
	metrics_leaderboard_updated.emit(Context1.leaderboard_json)

	
	for power_plant in get_tree().get_nodes_in_group("PP"):
		power_plant._disable_with_no_effect()
	for build_button in get_tree().get_nodes_in_group("BB"):
		build_button._disable_for_end_of_game()
	
	

func _on_show_ending_screen():
	show()


func _on_close_button_pressed():
	hide()
