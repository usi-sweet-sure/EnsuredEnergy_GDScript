extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.res_id_updated.connect(_on_res_id_updated)
	_on_res_id_updated(Context1.res_id)
	
	
func _on_res_id_updated(value: int):
	text = str(value)
