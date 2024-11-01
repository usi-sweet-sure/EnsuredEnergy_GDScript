extends Node

signal token_updated(token: String)
signal frame_updated(frame: int)
signal treatment_updated(treatment: int)
signal survey_ping_requested
signal back_to_survey_requested
signal survey_params_ready


var token_query_string_name = "res_tok"
var locale_query_string_name = "lang"
var frame_query_string_name = "frame"
var treatment_query_string_name = "treatment"
var token := "":
	set(new_value):
		token = new_value
		token_updated.emit(token)
var locale = ""
var frame := randi_range(0,1):
	set(new_value):
		frame = new_value
		frame_updated.emit(frame)
# 0 people playing the game after the survey (control group). 
# 1 people playing the game first (treatment group)
# -1 people playing the game with no survey or with survey actions disabled
var treatment := -1:
	set(new_value):
		treatment = new_value
		treatment_updated.emit(treatment)


func _ready():
	survey_ping_requested.connect(_on_survey_ping_requested)
	back_to_survey_requested.connect(_on_back_to_survey_requested)
	survey_params_ready.connect(_on_survey_params_ready)
	Gameloop.next_turn.connect(_on_next_turn)
	update_token()
	update_locale()
	update_frame()
	update_treatment()
	survey_params_ready.emit()
	

func update_token():
	var temp_token = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{token_query_string_name}')".format({"token_query_string_name": token_query_string_name}))
	
	if temp_token == null:
		temp_token = ""
	
	token = temp_token
	
	print("token: ", token)
	
	
func update_locale():
	var temp_locale = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{locale_query_string_name}')".format({"locale_query_string_name": locale_query_string_name}))
	
	if temp_locale == null:
		temp_locale = ""
	else:
		var available_locales = ["en", "de", "it", "fr"]
		
		if available_locales.find(temp_locale) == -1:
			temp_locale = "de"
	
	locale = temp_locale
	
	print("locale: ", locale)
	
	
func update_treatment():
	var temp_treatment = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{treatment_query_string_name}')".format({"treatment_query_string_name": treatment_query_string_name}))
	
	if temp_treatment == null:
		temp_treatment = "-1"
	else:
		if int(temp_treatment) != -1 or int(temp_treatment) != 0 or int(temp_treatment) != 1:
			temp_treatment = "-1"
		
	treatment = int(temp_treatment)
	print("trt: ", treatment)
	
# E. This code is kinda bad, but afraid to change it on the day of the release
func update_frame():
	var temp_frame = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{frame_query_string_name}')".format({"frame_query_string_name": frame_query_string_name}))
	
	if temp_frame != null and (int(temp_frame) == 0 or int(temp_frame) == 1):
		frame = int(temp_frame)
	else:
		frame_updated.emit(frame)
		
	print("frame: ", frame)
	
	
func open_back_to_survey_tab(target := "_blank"):
	var url = " https://sure.ethz.ch/api/sure/return-game?tokenGuid={tok}".format({"tok": token})
	var window = JavaScriptBridge.get_interface("window")
	
	if window != null and token != "":
		window.open(url, target)


func ping_the_survey():
	print("pinging survey", Gameloop.current_turn + 1)
	# The first ping is sent when the player arrives in the game, on the first turn.
	# The first ping sent must have a step 2, and then increment on each turn.
	# Which means step is current_turn + 1.
	var url = "https://sure.ethz.ch/api/sure/progress?tokenGuid={tok}&step={step}".format({"tok": token, "step": Gameloop.current_turn + 1})
	HttpManager.ping_survey(url)


func _on_survey_ping_requested():
	if is_survey_active():
		ping_the_survey()


func _on_back_to_survey_requested():
	if is_survey_active():
		open_back_to_survey_tab()


func _on_next_turn():
	survey_ping_requested.emit()


func is_survey_active() -> bool:
	print("Is survey active: ", token != "" and treatment != -1)
	return token != "" and treatment != -1


func _on_survey_params_ready():
	# The people from the survey want a ping when a user arrives on the game
	# from their survey. This is where the token is first retrieved and is
	# a good place to do it
	survey_ping_requested.emit()
