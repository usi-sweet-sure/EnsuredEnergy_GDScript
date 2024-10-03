extends Node

signal res_id_updated
signal res_name_updated
signal yr_updated
signal prm_id_updated
signal tj_updated
signal survey_token_updated
signal context_error

#the context
var ctx
var http
var leaderboard = false
var leaderboard_json = []
var rank = false
var rank_json
var category


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
var tj: float:
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
	
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._http_completed)
	
	
func register_new_game_on_model():
	if SurveyManager.token == "":
		SurveyManager.update_token()
		
	if res_name != "":
		var url = "https://sure.euler.usi.ch/json.php?mth=ins&res_name={res_name}".format({"res_name": res_name.uri_encode()})
		
		if SurveyManager.token != "":
			url += "&res_tok={tok}".format({"tok": SurveyManager.token.uri_encode()})
				
		HttpManager.http_request_active = true
		var error = http.request(url)
		if error != OK:
			push_error("http error")
	else:
		printerr("A res_name is needed (Player's name is probably missing)")
		
#upsert param
func send_parameters_to_model():
	var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}"
	HttpManager.http_request_active = true
	var error = http.request(url.format({"res_id": res_id, "yr": yr, "prm_id": prm_id, "tj": tj}))
	if error != OK:
		push_error("http error")
	

func get_context_from_model():
	var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}"
	HttpManager.http_request_active = true
	var error = http.request(url.format({"res_id": res_id, "yr": yr}))
	if error != OK:
		push_error("http error")
	
	
func get_leaderboard_from_model():
	leaderboard = true
	# TODO ask toby for a URL that gives the top 5 for all categories......
	var url = "https://sure.euler.usi.ch/json.php?mth=lst&lim=5&ord={category}"
	HttpManager.http_request_active = true
	var error = http.request(url.format({"category": category}))
	if error != OK:
		push_error("http error")
		
func get_rank():
	rank = true
	var url = "https://sure.euler.usi.ch/json.php?mth=rnk&res_id={res_id}"
	HttpManager.http_request_active = true
	var error = http.request(url.format({"res_id": res_id}))
	if error != OK:
		push_error("http error")
		
	
	
#handle response
func _http_completed(_result, _response_code, _headers, body):
	if leaderboard:
		HttpManager.http_request_active = false
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		leaderboard_json.append(json.get_data())
	elif !rank:
		HttpManager.http_request_active = false
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		ctx1 = json.get_data()
		if ctx1 == null:
			context_error.emit()
		elif Gameloop.current_turn == 1:
			res_id = int(ctx1[0]["res_id"])
			get_model_demand()
	else:
		HttpManager.http_request_active = false
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		rank_json = json.get_data()


func get_demand_from_model():
	for i in ctx:
		if i["prm_id"] == "455":
			Gameloop.demand_summer = float(i["tj"]) / 100.0
	for i in ctx: # sorry le code est cheum mais j'ai besoin de la demand_summer avant de pouvoir mettre la winter
		if i["prm_id"] == "435":
			Gameloop.demand_winter = (float(i["tj"]) / 100.0) - Gameloop.demand_summer


func _on_player_name_updated(player_name):
	res_name = player_name
