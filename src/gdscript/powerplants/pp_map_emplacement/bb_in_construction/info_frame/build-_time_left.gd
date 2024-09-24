extends Label

var build_time = 0
var built_on_turn = 0

func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)
	Gameloop.next_turn.connect(_on_next_turn)


func _on_locale_updated(_locale: String):
	_update_text()


func _on_metrics_updated(metrics: PowerplantMetrics):
	build_time = metrics.build_time_in_turns
	built_on_turn = metrics.built_on_turn
	_update_text()


func _update_text():
	var will_build_on_turn: int = built_on_turn + build_time
	var remaining_time = will_build_on_turn - Gameloop.current_turn
	
	if remaining_time > 1:
		text = str(remaining_time) + " " + tr("TURN")
	else:
		text = str(remaining_time) + " " + tr("TURNS")
		

func _on_next_turn():
	_update_text()
