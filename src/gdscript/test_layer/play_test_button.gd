extends Button

@onready var menu = $"../../Menu"

func _ready():
	Gameloop.game_started.connect(_on_game_started)


func _on_game_started():
	hide()
	
	
func _on_pressed():
	Gameloop.reset_all_values()
	Gameloop.player_name = "new123"
	Context.res_id = 1
	Context.yr = 2022
	Context.prm_id = 186
	Context.tj = 8000
	Context.get_context_from_model()
	hide()
	menu.hide()
