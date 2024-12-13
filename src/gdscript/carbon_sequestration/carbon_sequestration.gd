extends Control

@onready var wind_gusts_left: Array[WindGust] = [$WindGustLeft1, $WindGustLeft2, $WindGustLeft3]
@onready var wind_gusts_right: Array[WindGust] = [$WindGustRight1, $WindGustRight2, $WindGustRight3]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gameloop.sequestrated_co2_updated.connect(_on_sequestrated_co2_updated)



func _on_sequestrated_co2_updated(value: float):
	var percentage_of_sequestrated_co2 = value / Gameloop.co2_emissions * 100.0
	
	if percentage_of_sequestrated_co2 > 0:
		var number_of_wind_gust = 1
		
		if percentage_of_sequestrated_co2 > 66:
			number_of_wind_gust = 3
		elif percentage_of_sequestrated_co2 > 33:
			number_of_wind_gust = 2
			
		for i in wind_gusts_left.size():
			if i < number_of_wind_gust:
				var wind_gust = wind_gusts_left[i]
				
				if not wind_gust.active:
					wind_gust.activate()
					
				wind_gust = wind_gusts_right[i]
				if not wind_gust.active:
					wind_gust.activate()
			else:
				wind_gusts_left[i].deactivate()
				wind_gusts_right[i].deactivate()
	else:
		for gust in wind_gusts_left:
			gust.deactivate()
			
		for gust in wind_gusts_right:
			gust.deactivate()
