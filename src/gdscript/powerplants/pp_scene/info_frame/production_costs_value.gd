extends Label


func _ready():
	position = Vector2(-240, 18)
	
	
func _on_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.production_costs).pad_decimals(0) + "M CHF"
