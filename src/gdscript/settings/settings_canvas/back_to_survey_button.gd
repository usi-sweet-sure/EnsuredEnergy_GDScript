extends TextureButton

func _ready():
	SurveyManager.survey_params_ready.connect(_on_token_updated)
	_on_token_updated(SurveyManager.token)
	
	
func _on_pressed():
	SurveyManager.back_to_survey_requested.emit()


func _on_token_updated(_token: String):
	visible = SurveyManager.is_survey_active()
