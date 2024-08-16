extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.yr_updated.connect(_on_yr_updated)
	_on_yr_updated(Context1.yr)

func _on_yr_updated(value: int):
	text = str(value)
