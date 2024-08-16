extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.survey_token_updated.connect(_on_token_updated)
	_on_token_updated(Context1.survey_token)
	

func _on_token_updated(value: String):
	text = value
