extends TextureRect

@onready var animation_player = $AnimationPlayer

var powerplant_type = null

# Used by childrens to update their state
signal powerplant_metrics_updated(metrics: PowerplantMetrics)


func _ready():
	PowerplantsManager.powerplants_metrics_updated.connect(_on_powerplant_metrics_updated)


# Used when instanciating a button in "pp_menu.gd"
func assign_powerplant(type_id: PowerplantsManager.EngineTypeIds):
	powerplant_type = type_id
	_on_powerplant_metrics_updated(PowerplantsManager.powerplants_metrics)


func _on_button_mouse_entered():
	# Original position is (x,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, -15), 0.1)

	animation_player.play("info_frame_show")
	

func _on_button_mouse_exited():
	# Original position is (x,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 0), 0.1)
	
	animation_player.play("info_frame_hide")


func _on_powerplant_metrics_updated(all_metrics: Array[PowerplantMetrics]):
	powerplant_metrics_updated.emit(all_metrics[powerplant_type])
