extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	var winter_supply: String = str(metrics.availability.y * metrics.capacity).pad_decimals(0)
	
	if winter_supply.length() == 3:
		text = winter_supply[2]
	elif winter_supply.length() == 2:
		text = winter_supply[1]
	else:
		text = winter_supply
