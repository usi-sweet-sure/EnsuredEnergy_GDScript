extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.tj_updated.connect(_on_tj_updated)
	_on_tj_updated(Context1.tj)

func _on_tj_updated(value: int):
	text = str(value)
