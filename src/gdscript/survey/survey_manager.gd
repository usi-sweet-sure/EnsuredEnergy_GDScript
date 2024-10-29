extends Node

signal token_updated(token: String)
signal frame_updated(frame: int)
signal survey_ping_requested
signal back_to_survey_requested


var token_query_string_name = "res_tok"
var locale_query_string_name = "lang"
var frame_query_string_name = "frame"
var token := "":
	set(new_value):
		token = new_value
		token_updated.emit(token)
var locale = ""
var frame := randi_range(0,1):
	set(new_value):
		frame = new_value
		frame_updated.emit(frame)


func _ready():
	update_token()
	update_locale()
	update_frame()
	survey_ping_requested.connect(_on_survey_ping_requested)
	back_to_survey_requested.connect(_on_back_to_survey_requested)
	

func update_token():
	var temp_token = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{token_query_string_name}')".format({"token_query_string_name": token_query_string_name}))
	
	if temp_token == null:
		temp_token = ""
	else:
		# The people from the survey want a ping when a user arrives on the game
		# from their survey. This is where the token is first retrieved and is
		# a good place to do it
		ping_the_survey()
		
	token = temp_token
	
	
func update_locale():
	var temp_locale = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{locale_query_string_name}')".format({"locale_query_string_name": locale_query_string_name}))
	
	if temp_locale == null:
		temp_locale = ""
		
	locale = temp_locale
	

func update_frame():
	var temp_frame = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{frame_query_string_name}')".format({"frame_query_string_name": frame_query_string_name}))
	
	if temp_frame != null:
		frame = int(temp_frame)
	else:
		frame_updated.emit(frame)
	
	
func open_back_to_survey_tab(target := "_blank"):
	var url = "https://unibe.eu.qualtrics.com/jfe/form/SV_2lvvzqrI2fWxiwC?keyback={tok}".format({"tok": token})
	var window = JavaScriptBridge.get_interface("window")
	
	if window != null and token != "":
		window.open(url, target)


func ping_the_survey():
	print("Survey ping")
	var url = "https://api.github.com/repos/godotengine/godot/releases/latest"
	HttpManager.make_request(url)


func _on_survey_ping_requested():
	ping_the_survey()


func _on_back_to_survey_requested():
	open_back_to_survey_tab()
