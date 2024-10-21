extends HSlider

@export var audio_bus_name := "Master"
@onready var _bus := AudioServer.get_bus_index(audio_bus_name)


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))


func _on_value_changed(value_):
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value_))
