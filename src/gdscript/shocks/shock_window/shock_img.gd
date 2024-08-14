# E. This is currently not used. Delete this script and the corresponding node if it stays this way
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.most_recent_shock_updated.connect(_on_most_recent_shock_updated)


func _on_most_recent_shock_updated(shock: Shock):
	pass
	#texture = load("res://assets/icons/" + shock.img)
