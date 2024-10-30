extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	SurveyManager.token_updated.connect(_on_token_updated)
	_on_token_updated(SurveyManager.token)

func _on_token_updated(token: String):
	visible = SurveyManager.is_survey_active()
