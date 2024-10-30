extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SurveyManager.token_updated.connect(_on_token_updated)
	SurveyManager.survey_ping_requested.connect(_on_ping_requested)
	SurveyManager.back_to_survey_requested.connect(_on_back_to_survey)
	SurveyManager.frame_updated.connect(_on_frame_updated)


func _on_token_updated(token: String):
	text += "\nToken updated : " + token


func _on_ping_requested():
	text += "\nPinged survey: " + str(Gameloop.current_turn + 1)
	
	
func _on_back_to_survey():
	text += "\nBack to survey tab should open"


func _on_frame_updated(frame: int):
	text += "\nFrame updated: " + str(frame)
