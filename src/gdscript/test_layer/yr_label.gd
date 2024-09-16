extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context.yr_updated.connect(_on_yr_updated)
	_on_yr_updated(Context.yr)

func _on_yr_updated(value: int):
	text = str(value)
