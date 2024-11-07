extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	var summer_supply: String = str(metrics.availability.x * metrics.capacity).pad_decimals(0)
	
	if summer_supply.length() == 3:
		text = summer_supply[2]
	elif summer_supply.length() == 2:
		text = summer_supply[1]
	else:
		text = summer_supply
