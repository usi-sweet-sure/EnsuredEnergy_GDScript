extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	if shock != null and shock.img != "":
		texture = load(shock.img)
