extends Node

signal token_updated

var token_query_param_name = "res_tok"
var token := "":
	set(new_value):
		token = new_value
		token_updated.emit(token)


func _ready():
	update_token()


func update_token():
	var temp_token = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('{token_query_param_name}')".format({"token_query_param_name": token_query_param_name}))
	
	if temp_token == null:
		temp_token = ""
		
	token = temp_token
