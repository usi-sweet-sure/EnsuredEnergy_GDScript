extends Label

var text_key = ""

func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)
	

func _on_powerplant_metrics_updated(metrics: PowerplantMetrics):
	text_key = PowerplantsManager.EngineTypeIds.keys()[metrics.type]
	text = tr(text_key)


func _on_locale_updated(_locale):
	text = tr(text_key)
