extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.res_name_updated.connect(_on_res_name_updated)
	_on_res_name_updated(Context1.res_name)
	

func _on_res_name_updated(value: String):
	text = value
