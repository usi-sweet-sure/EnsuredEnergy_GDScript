extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Context.survey_token_updated.connect(_on_token_updated)
	_on_token_updated(Context.survey_token)
	

func _on_token_updated(value: String):
	text = value
