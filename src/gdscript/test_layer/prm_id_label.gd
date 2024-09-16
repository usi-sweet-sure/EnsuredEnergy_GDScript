extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context.prm_id_updated.connect(_on_prm_id_updated)
	_on_prm_id_updated(Context.prm_id)

func _on_prm_id_updated(value: int):
	text = str(value)
