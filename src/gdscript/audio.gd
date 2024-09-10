extends Node


@onready var forest_ambiance: AudioStreamPlayer = $ForestAmbiance
@onready var water: AudioStreamPlayer2D = $Water
@onready var water_2: AudioStreamPlayer2D = $Water2
@onready var wind: AudioStreamPlayer2D = $Wind
@onready var dark_fantasy: AudioStreamPlayer = $DarkFantasy
@onready var button_hover = $ButtonHover
@onready var button_press = $ButtonPress


func _ready():
	#dark_fantasy.play()
	Gameloop.game_started.connect(_on_game_started)
	Gameloop.game_ended.connect(_on_game_ended)
	var buttons: Array = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.pressed.connect(_on_button_pressed)


func _on_game_started():
	forest_ambiance.play()
	#$AnimationPlayer.play("fade_out")
	

func _on_game_ended():
	dark_fantasy.volume_db = 0
	dark_fantasy.play()
	# animation player fade in
	forest_ambiance.stop()


# E. To remove
func _on_play_test_button_pressed():
	_on_game_started()


func _on_button_mouse_entered():
	button_hover.play()


func _on_button_pressed():
	button_press.play()
