extends Label


func _on_metrics_updated(metrics: PowerplantMetrics):
	var winter_supply: String = str(metrics.availability.y * metrics.capacity).pad_decimals(0)
	
	if winter_supply.length() == 3:
		text = winter_supply[1]
		custom_show()
	elif winter_supply.length() == 2:
		text = winter_supply[0]
		custom_show()
	else:
		custom_hide()


# The label has to take place to align the other digits correctly, since they 
# are in a hboxcontainer. So we don't hide it, but turn it's alpha to zero
func custom_hide():
	set_self_modulate(Color(1, 1, 1, 0))
	
func custom_show():
	set_self_modulate(Color(1, 1, 1, 1))
