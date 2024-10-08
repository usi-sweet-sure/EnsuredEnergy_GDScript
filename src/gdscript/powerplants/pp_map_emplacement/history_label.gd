extends Label


func _ready():
	Gameloop.next_turn.connect(func(): text = "")
	

func _on_pp_map_emplacement_history_updated(history: MapEmplacementHistory):
	var what_happened = history.get_history_meaning(Gameloop.current_turn)
	text = MapEmplacementHistory.PossibleActions.keys()[what_happened]
