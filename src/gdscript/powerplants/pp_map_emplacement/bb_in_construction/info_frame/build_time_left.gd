extends Label

var build_time = 0
var construction_started_on_turn = 0

func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)
	Gameloop.next_turn.connect(_on_next_turn)


func _on_metrics_updated(metrics: PowerplantMetrics):
	build_time = metrics.build_time_in_turns
	construction_started_on_turn = metrics.construction_started_on_turn
	_update_text()


func _update_text():
	var will_build_on_turn: int = construction_started_on_turn + build_time
	var remaining_time = will_build_on_turn - Gameloop.current_turn

	if remaining_time > 1:
		text = str(remaining_time) + " " + tr("TURNS")
	else:
		text = str(remaining_time) + " " + tr("TURN")
		

func _on_next_turn():
	_update_text()


func _on_locale_updated(_locale):
	_update_text()
