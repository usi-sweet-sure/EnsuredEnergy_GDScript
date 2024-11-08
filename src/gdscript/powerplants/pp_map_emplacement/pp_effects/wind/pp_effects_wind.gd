extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wind_gust_1: WindGust = $WindGust

var wind_gusts: Array[WindGust]
var wind_gust_scene


func _ready():
	wind_gust_scene = load("res://scenes/wind_gust.tscn")
	wind_gusts.append(wind_gust_1)
	
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)


func effects_off(_metrics: PowerplantMetrics):
	animation_player.stop()
	
	for wind_gust in wind_gusts:
		wind_gust.deactivate()
	
	
func effects_on(_metrics: PowerplantMetrics):
	animation_player.play("rotate_clockwise")
	
	for wind_gust in wind_gusts:
		wind_gust.activate()
		await get_tree().create_timer(randf_range(0, 1)).timeout
	
	
func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	var new_wind_gust: WindGust = wind_gust_scene.instantiate()
	add_child(new_wind_gust)
	new_wind_gust.position = Vector2(-794, 429)
	new_wind_gust.rotation = -38.5
	new_wind_gust.random_y_offset = 200
	wind_gusts.append(new_wind_gust)
	new_wind_gust.activate()
	animation_player.speed_scale += 0.25


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	var removed_wind_gust = wind_gusts.pop_back()
	remove_child(removed_wind_gust)
	removed_wind_gust.queue_free()
	animation_player.speed_scale -= 0.25
