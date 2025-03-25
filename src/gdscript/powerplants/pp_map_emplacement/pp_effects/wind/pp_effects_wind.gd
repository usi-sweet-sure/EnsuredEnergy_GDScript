extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wind_gust_1: WindGust = $WindGust

var wind_gusts: Array[WindGust]
var wind_gust_scene

var is_construction_animation_finished = false


func _ready():
	var pp_scene: PpScene = get_parent()
	pp_scene.construction_animation_finished.connect(construction_animation_finished)

	wind_gust_scene = load("res://scenes/wind_gust.tscn")
	wind_gusts.append(wind_gust_1)
	
	animation_player.play("upgrade" + str(0))
	
	for wind_gust in wind_gusts:
		wind_gust.activate()
		await get_tree().create_timer(randf_range(0, 1)).timeout
	
	# Disables the effects during the  build animation
	if not pp_scene.built_on_start and not is_construction_animation_finished:
		animation_player.play("RESET")
	
		for wind_gust in wind_gusts:
			wind_gust.deactivate()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)


func effects_off(_metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	animation_player.play("RESET")
	
	for wind_gust in wind_gusts:
		wind_gust.deactivate()
	
	
func effects_on(metrics: PowerplantMetrics):
	if is_construction_animation_finished:
		animation_player.play("upgrade" + str(metrics.current_upgrade))
		
		for wind_gust in wind_gusts:
			wind_gust.activate()
			await get_tree().create_timer(randf_range(0, 1)).timeout
	
	
func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("upgrade" + str(metrics.current_upgrade))
	
	var new_wind_gust: WindGust = wind_gust_scene.instantiate()
	add_child(new_wind_gust)
	new_wind_gust.position = Vector2(-794, 429)
	new_wind_gust.rotation = -38.5
	new_wind_gust.random_y_offset = 200
	wind_gusts.append(new_wind_gust)
	new_wind_gust.activate()
	animation_player.speed_scale += 0.10


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play("upgrade" + str(metrics.current_upgrade))
	
	var removed_wind_gust = wind_gusts.pop_back()
	remove_child(removed_wind_gust)
	removed_wind_gust.queue_free()
	animation_player.speed_scale -= 0.10


func construction_animation_finished(metrics: PowerplantMetrics):
	is_construction_animation_finished = true
	effects_on(metrics)
