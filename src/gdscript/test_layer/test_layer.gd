extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	Gameloop.testing_env_entered.connect(_on_testing_env_entered)


func _on_testing_env_entered():
	show()
