extends Node

signal context_updated(context)
signal parameters_sent_to_model
signal leaderboard_updated(leaderboard)
signal rank_updated(rank)

#the context
var res_id: int
var ctx
var leaderboard_json = []
var rank_json
var survey_token: String

	
func register_new_game_on_model(player_name: String):
	if SurveyManager.token == "":
		SurveyManager.update_token()
		
	if player_name != "":
		var url = "https://sure.euler.usi.ch/json.php?mth=ins&res_name={res_name}".format({"res_name": player_name.uri_encode()})
		
		if SurveyManager.token != "":
			url += "&res_tok={tok}".format({"tok": SurveyManager.token.uri_encode()})
		
		HttpManager.http_request_completed.connect(_on_got_context_from_model)
		HttpManager.make_request(url)
	else:
		printerr("A res_name is needed (Player's name is probably missing)")


#upsert param
func send_parameters_to_model(game_id: int, year: int, prm_id: int, tj: int):
	var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}".format({"res_id": game_id, "yr": year, "prm_id": prm_id, "tj": tj})
	
	HttpManager.http_request_completed.connect(_on_parameters_sent_to_model)
	HttpManager.make_request(url)
	

func get_context_from_model(game_id: int, year: InternalMode):
	var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}".format({"res_id": game_id, "yr": year})
	
	HttpManager.http_request_completed.connect(_on_got_context_from_model)
	HttpManager.make_request(url)
	
	
func get_leaderboard_from_model(category: String):
	# TODO ask toby for a URL that gives the top 5 for all categories......
	var url = "https://sure.euler.usi.ch/json.php?mth=lst&lim=5&ord={category}".format({"category": category})
	
	HttpManager.http_request_completed.connect(_on_got_leaderboard_from_model)
	HttpManager.make_request(url)
		
		
func get_rank(game_id: int):
	var url = "https://sure.euler.usi.ch/json.php?mth=rnk&res_id={res_id}".format({"res_id": game_id})
	
	HttpManager.http_request_completed.connect(_on_got_rank_from_model)
	HttpManager.make_request(url)


func get_demand_from_model():
	for i in ctx:
		if i["prm_id"] == "455":
			Gameloop.demand_summer = float(i["tj"]) / 100.0
	for i in ctx: # sorry le code est cheum mais j'ai besoin de la demand_summer avant de pouvoir mettre la winter
		if i["prm_id"] == "435":
			Gameloop.demand_winter = (float(i["tj"]) / 100.0) - Gameloop.demand_summer


func _on_got_context_from_model(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	ctx = json.get_data()
	
	if ctx!= null and Gameloop.current_turn == 1:
		res_id = int(ctx[0]["res_id"])
		get_demand_from_model()
		
	HttpManager.http_request_completed.disconnect(_on_got_context_from_model)
	context_updated.emit(ctx)
	

func _on_parameters_sent_to_model(_result, _response_code, _headers, _body):
	HttpManager.http_request_completed.disconnect(_on_parameters_sent_to_model)
	parameters_sent_to_model.emit()


func _on_got_leaderboard_from_model(_result, _response_code, _headers, body):
	HttpManager.http_request_completed.disconnect(_on_got_leaderboard_from_model)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	leaderboard_json.append(json.get_data())
	leaderboard_updated.emit(leaderboard_json)


func _on_got_rank_from_model(_result, _response_code, _headers, body):
	HttpManager.http_request_completed.disconnect(_on_got_rank_from_model)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	rank_json = json.get_data()
	rank_updated.emit(rank_json)
