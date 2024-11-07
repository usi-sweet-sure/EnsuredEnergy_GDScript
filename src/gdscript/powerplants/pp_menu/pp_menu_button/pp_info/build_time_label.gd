extends Label

var build_time := 0


func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	build_time = metrics.build_time_in_turns
	_set_text()


func _on_locale_updated(_locale):
	_set_text()


func _set_text():
	if build_time > 0:
		show()
		text = tr("TURNS_TO_BUILD") + " " + str(build_time) + " " + tr("TURNS").to_lower()
	else:
		hide()
