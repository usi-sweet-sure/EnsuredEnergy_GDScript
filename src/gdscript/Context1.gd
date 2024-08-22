extends Node

signal res_id_updated
signal res_name_updated
signal yr_updated
signal prm_id_updated
signal tj_updated
signal survey_token_updated
signal context_error

#the context
var ctx1
var http1
var leaderboard = false
var leaderboard_json

#globals
var res_id: int:
	set(new_value):
		res_id = new_value
		res_id_updated.emit(res_id)
var res_name: String:
	set(new_value):
		res_name = new_value
		res_name_updated.emit(res_name)
var yr: int:
	set(new_value):
		yr = new_value
		yr_updated.emit(yr)
var prm_id: int:
	set(new_value):
		prm_id = new_value
		prm_id_updated.emit(prm_id)
var tj: int:
	set(new_value):
		tj = new_value
		tj_updated.emit(tj)
var survey_token: String:
	set(new_value):
		survey_token = new_value
		survey_token_updated.emit(survey_token)


#init
func _ready():
	Gameloop.player_name_updated.connect(_on_player_name_updated)
	_on_player_name_updated(Gameloop.player_name)
	
	http1 = HTTPRequest.new()
	add_child(http1)
	http1.request_completed.connect(self._http1_completed)
	#res_ins()
	#prm_ups()
	
	
#new game
func res_ins():
	if SurveyManager.token == "":
		SurveyManager.update_token()
		
	if res_name != "":
		var url = "https://sure.euler.usi.ch/json.php?mth=ins&res_name={res_name}".format({"res_name": res_name.uri_encode()})
		
		if SurveyManager.token != "":
			url += "&res_tok={tok}".format({"tok": SurveyManager.token.uri_encode()})
				
		HttpManager.http_request_active = true
		var error = http1.request(url)
		if error != OK:
			push_error("http error")
	else:
		printerr("A res_name is needed (Player's name is probably missing)")
		
#upsert param
func prm_ups():
	var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}"
	HttpManager.http_request_active = true
	var error = http1.request(url.format({"res_id": res_id, "yr": yr, "prm_id": prm_id, "tj": tj}))
	if error != OK:
		push_error("http error")
	
		
#you dont need this function - res_ins or prm_ups returns the context
func get_ctx():
	var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}"
	HttpManager.http_request_active = true
	var error = http1.request(url.format({"res_id": res_id, "yr": yr}))
	if error != OK:
		push_error("http error")
	
	
func get_leaderboard():
	leaderboard = true
	var url = "https://sure.euler.usi.ch/json.php?mth=lst&lim=3&ord=5"
	HttpManager.http_request_active = true
	var error = http1.request(url)
	if error != OK:
		push_error("http error")
	
#handle response
func _http1_completed(_result, _response_code, _headers, body):
	if !leaderboard:
		HttpManager.http_request_active = false
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		ctx1 = json.get_data()
		#set globals
		#res_id = ctx1[0]["res_id"]
		#yr = ctx1[0]["yr"]
		#debug
		#print(ctx1[0]["res_id"])
		#print(ctx1[0]["yr"])
		#print(ctx1[0]["cnv_gas_gas"])
		if ctx1 == null:
			context_error.emit()
		else:
			for i in ctx1:
				if i["prm_id"] == "454":
					Gameloop.demand_summer = float(i["tj"]) / 100
				if i["prm_id"] == "455":
					Gameloop.demand_winter = float(i["tj"]) / 100
					
	else:
		HttpManager.http_request_active = false
		var json = JSON.new()
		leaderboard_json = JSON.stringify(JSON.parse_string(body.get_string_from_utf8()))
		#leaderboard_json = json.get_data()
		print(leaderboard_json)


func _on_player_name_updated(player_name):
	res_name = player_name
