extends Node


@onready var forest_ambiance: AudioStreamPlayer = $ForestAmbiance
@onready var water: AudioStreamPlayer2D = $Water
@onready var water_2: AudioStreamPlayer2D = $Water2
@onready var wind: AudioStreamPlayer2D = $Wind
@onready var dark_fantasy: AudioStreamPlayer = $DarkFantasy


func _ready():
	dark_fantasy.play()
	Gameloop.game_started.connect(_on_game_started)
	Gameloop.game_ended.connect(_on_game_ended)


func _on_game_started():
	forest_ambiance.play()
	$AnimationPlayer.play("fade_out")
	

func _on_game_ended():
	dark_fantasy.volume_db = 0
	dark_fantasy.play()
	# animation player fade in
	forest_ambiance.stop()

# E. To remove
func _on_play_test_button_pressed():
	_on_game_started()
