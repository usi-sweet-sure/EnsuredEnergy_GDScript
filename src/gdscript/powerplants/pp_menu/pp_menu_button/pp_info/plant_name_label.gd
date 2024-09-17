extends Label

var type =  null

func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	type = metrics.type
	_set_text()


func _on_locale_updated(_locale):
	_set_text()
	

func _set_text():
	if type != null:
		text = tr(PowerplantsManager.EngineTypeIds.keys()[type])
