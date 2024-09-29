extends Label

var life_span := 0
var built_on_turn := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_locale_updated(_locale: String):
	_update_text()
	
	
func _update_text():
	var shutting_down_in = life_span - (Gameloop.current_turn - built_on_turn)
	var remaining_turns = Gameloop.total_number_of_turns - Gameloop.current_turn + 1
	
	if shutting_down_in <= remaining_turns:
		if shutting_down_in == 1:
			text = tr("SHUT_DOWN_NEXT_TURN")
			show()
		elif shutting_down_in == 0:
			hide()
		else:
			text = tr("SHUT_DOWN").format({nbr = str(shutting_down_in)})
			show()

	else:
		hide()


func _on_metrics_updated(metrics: PowerplantMetrics):
	life_span = metrics.life_span_in_turns
	built_on_turn = metrics.built_on_turn
	_update_text()
