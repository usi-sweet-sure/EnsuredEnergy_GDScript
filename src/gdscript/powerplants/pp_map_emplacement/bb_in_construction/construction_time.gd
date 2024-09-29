extends Label

var build_time = 0
var construction_started_on_turn = 0

func _ready():
	Gameloop.next_turn.connect(_on_next_turn)


func _on_metrics_updated(metrics: PowerplantMetrics):
	build_time = metrics.build_time_in_turns
	construction_started_on_turn = metrics.construction_started_on_turn
	_update_text()


func _update_text():
	print("construction_started_on_turn: ", construction_started_on_turn)
	print("build_time: ", build_time)
	var will_build_on_turn: int = construction_started_on_turn + build_time
	print("will_build_on_turn: ", will_build_on_turn)
	var remaining_time = will_build_on_turn - Gameloop.current_turn
	print("remaining_time: ", remaining_time)
	print("===========================================")

	text = str(remaining_time)
		

func _on_next_turn():
	_update_text()
