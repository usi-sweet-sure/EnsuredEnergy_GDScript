extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.context_error.connect(_on_context_error)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_context_error():
	show()
