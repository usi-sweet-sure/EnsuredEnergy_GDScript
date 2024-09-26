extends Label

var life_span := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_locale_updated(_locale: String):
	_update_text()
	
	
func _update_text():
	var shutting_down_in = life_span # E. not, use built on turn
	
	if Gameloop.current_turn + shutting_down_in < Gameloop.total_number_of_turns:
		hide()
	else:
		show()
		text = tr("SHUT_DOWN").format({nbr = str(shutting_down_in)}) 


func _on_metrics_updated(metrics: PowerplantMetrics):
	life_span = metrics.life_span_in_turns
	_update_text()
