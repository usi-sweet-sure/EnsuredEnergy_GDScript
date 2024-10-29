extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SurveyManager.token_updated.connect(_on_token_updated)
	SurveyManager.survey_ping_requested.connect(_on_ping_requested)
	SurveyManager.back_to_survey_requested.connect(_on_back_to_survey)


func _on_token_updated(token: String):
	text += "\ntoken updated : " + token


func _on_ping_requested():
	text += "\nping requested"
	
	
func _on_back_to_survey():
	text += "\nback to survey"
