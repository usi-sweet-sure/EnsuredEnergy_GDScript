extends Label


func _ready():
	position = Vector2(-240, 18)
	

func _on_metrics_updated(metrics: PowerplantMetrics):
	text = str(metrics.emissions).pad_decimals(2) + "Mt CO2"
	if metrics.emissions <= 0:
		_change_text_to_green()
	else:
		_change_text_to_red()
	
	
func _change_text_to_green():
	set("theme_override_colors/font_color", Color(0,0.882,0))
	

func _change_text_to_red():
	set("theme_override_colors/font_color", Color(1.0, 0.129, 0.208))
