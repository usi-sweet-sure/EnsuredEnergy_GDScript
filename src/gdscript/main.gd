extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.end.connect(_show_end_score)


func _show_end_score():
	#TODO set score fields
	Context1.get_leaderboard()
	await Context1.http1.request_completed
	$End.leaderboard.text = Context1.leaderboard_json
	$End.show()
	for power_plant in get_tree().get_nodes_in_group("PP"):
		power_plant.multiplier.hide()
	for build_button in get_tree().get_nodes_in_group("BB"):
		build_button.disabled = true
