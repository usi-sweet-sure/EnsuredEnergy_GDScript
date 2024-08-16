extends Button

@onready var menu = $"../../Menu"

func _ready():
	Gameloop.game_started.connect(_on_game_started)


func _on_game_started():
	hide()
	
	
func _on_pressed():
	Gameloop.reset_all_values()
	Gameloop.player_name = "new123"
	Context1.res_id = 1
	Context1.yr = 2022
	Context1.prm_id = 186
	Context1.tj = 8000
	Context1.get_ctx()
	hide()
	menu.hide()
