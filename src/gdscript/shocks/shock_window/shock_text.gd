extends Label


func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock):
	text = tr(shock.text_key)
