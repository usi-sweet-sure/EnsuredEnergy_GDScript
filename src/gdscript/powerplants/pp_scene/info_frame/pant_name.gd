extends Label

var text_key: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_metrics_updated(metrics: PowerplantMetrics):
	text_key = PowerplantsManager.EngineTypeIds.keys()[metrics.type]
	_update_text()


func _on_locale_updated(_locale: String):
	_update_text()
	

func _update_text():
	text = tr(text_key)
