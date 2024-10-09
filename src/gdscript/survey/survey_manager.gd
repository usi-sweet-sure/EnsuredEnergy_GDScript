extends Node

signal token_updated

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


func update_token():
	var temp_token = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{token_query_param_name}')".format({"token_query_param_name": token_query_param_name}))
	
	if temp_token == null:
		temp_token = ""
		
	token = temp_token
	
	
func update_locale():
	var temp_locale = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{locale_query_param_name}')".format({"locale_query_param_name": locale_query_param_name}))
	
	if temp_locale == null:
		temp_locale = ""
		
	locale = temp_locale
	
	
func open_back_to_survey_tab(target := "_blank"):
	var url = "https://unibe.eu.qualtrics.com/jfe/form/SV_2lvvzqrI2fWxiwC?keyback={tok}".format({"tok": token})
	var window = JavaScriptBridge.get_interface("window")
	
	if window != null and token != "":
		window.open(url, target)
