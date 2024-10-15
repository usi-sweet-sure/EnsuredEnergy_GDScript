extends Node

signal token_updated
signal survey_ping_requested
signal back_to_survey_requested


var token_query_param_name = "res_tok"
var locale_query_param_name = "lang"
var token := "":
	set(new_value):
		token = new_value
		token_updated.emit(token)
var locale = ""


func _ready():
	update_token()
	update_locale()
	survey_ping_requested.connect(_on_survey_ping_requested)
	back_to_survey_requested.connect(_on_back_to_survey_requested)

func update_token():
	var temp_token = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{token_query_param_name}')".format({"token_query_param_name": token_query_param_name}))
	
	if temp_token == null:
		temp_token = ""
	else:
		# The people from the survey want a ping when a user arrives on the game
		# from their survey. This is where the token is first retrieved and is
		# a good place to do it
		ping_the_survey()
		
	token = temp_token
	
	
func update_locale():
	var temp_locale = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{locale_query_param_name}')".format({"locale_query_param_name": locale_query_param_name}))
	
	if temp_locale == null:
		temp_locale = ""
		
	locale = temp_locale
	
	
func open_back_to_survey_tab(target := "_blank"):
	print("back to survey")
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
