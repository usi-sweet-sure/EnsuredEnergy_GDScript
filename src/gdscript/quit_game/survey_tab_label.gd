extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	SurveyManager.survey_params_ready.connect(_on_token_updated)
	_on_token_updated(SurveyManager.token)


func _on_token_updated(_token: String):
	visible = SurveyManager.is_survey_active()
