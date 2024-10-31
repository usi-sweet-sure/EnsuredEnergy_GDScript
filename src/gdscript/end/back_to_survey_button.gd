extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SurveyManager.survey_params_ready.connect(_on_token_updated)
	_on_token_updated(SurveyManager.token)


func _on_token_updated(token: String) -> void:
	visible = SurveyManager.is_survey_active()


func _on_pressed() -> void:
	SurveyManager.back_to_survey_requested.emit()
