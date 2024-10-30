extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SurveyManager.token_updated.connect(_on_token_updated)
	SurveyManager.survey_ping_requested.connect(_on_ping_requested)
	SurveyManager.back_to_survey_requested.connect(_on_back_to_survey)
	SurveyManager.frame_updated.connect(_on_frame_updated)
	SurveyManager.treatment_updated.connect(_on_treatment_updated)


func _on_token_updated(token: String):
	if SurveyManager.is_survey_active():
		text += "\nToken updated : " + token


func _on_ping_requested():
	if SurveyManager.is_survey_active():
		text += "\nPinged survey: " + str(Gameloop.current_turn + 1)
	
	
func _on_back_to_survey():
	if SurveyManager.is_survey_active():
		text += "\nBack to survey tab should open"


func _on_frame_updated(frame: int):
	if SurveyManager.is_survey_active():
		text += "\nFrame updated: " + str(frame)


func _on_treatment_updated(treatment: int) -> void:
	if SurveyManager.is_survey_active():
		text += "\nTreatment updated: " + str(treatment)
