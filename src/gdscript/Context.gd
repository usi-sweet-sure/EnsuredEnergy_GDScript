extends Node

signal context_updated(context)
signal parameters_sent_to_model
signal leaderboard_updated(leaderboard)
signal rank_updated(rank)
signal shocks_sent_to_model
signal player_name_changed

#the context
var res_id: int
var ctx
var leaderboard_json = []
var rank_json
var survey_token: String
var context_updated_for_new_turn = false


func register_new_game_on_model(player_name: String):
	if player_name != "":
		var url = "https://sure.euler.usi.ch/json.php?mth=ins&res_name={res_name}".format({"res_name": player_name.uri_encode()})
		
		if SurveyManager.token != "":
			url += "&res_tok={tok}".format({"tok": SurveyManager.token.uri_encode()})
			
		var lang = SurveyManager.locale
		
		if lang == "":
			lang = TranslationServer.get_locale()
		
		var lang_index = ["de", "fr", "it", "en"].find(lang) + 1
			
		url += "&res_lng={lang}".format({"lang": lang_index})

		url += "&res_frm={frame}".format({"frame": str(SurveyManager.frame)})
		
		url += "&res_trt={treatment}".format({"treatment": str(SurveyManager.treatment)})

		HttpManager.http_request_completed.connect(_on_got_context_from_model)
		HttpManager.make_request(url)
	else:
		printerr("A res_name is needed (Player's name is probably missing)")


#upsert param
func send_parameters_to_model(game_id: int, year: int, prm_id: int, tj: float):
	print("prms year ", year)
	var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}".format({"res_id": game_id, "yr": year, "prm_id": prm_id, "tj": tj})
	
	if not HttpManager.http_request_completed.is_connected(_on_parameters_sent_to_model):
		HttpManager.http_request_completed.connect(_on_parameters_sent_to_model)
	HttpManager.make_request(url)
	

func get_context_from_model(game_id: int, year: int):
	print("context year ", year)
	var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}".format({"res_id": game_id, "yr": year})
	
	if not HttpManager.http_request_completed.is_connected(_on_got_context_from_model):
		HttpManager.http_request_completed.connect(_on_got_context_from_model)
	HttpManager.make_request(url)
	
	
func get_leaderboard_from_model(category: String):
	# TODO ask toby for a URL that gives the top 5 for all categories......
	var url = "https://sure.euler.usi.ch/json.php?mth=lst&lim=5&ord={category}".format({"category": category})
	
	if not HttpManager.http_request_completed.is_connected(_on_got_leaderboard_from_model):
		HttpManager.http_request_completed.connect(_on_got_leaderboard_from_model)
	HttpManager.make_request(url)
		
		
func get_rank(game_id: int):
	var url = "https://sure.euler.usi.ch/json.php?mth=rnk&res_id={res_id}".format({"res_id": game_id})
	
	if not HttpManager.http_request_completed.is_connected(_on_got_rank_from_model):
		HttpManager.http_request_completed.connect(_on_got_rank_from_model)
	HttpManager.make_request(url)
	
	
func change_player_name(game_id: int, player_name: String):
	var url = "https://sure.euler.usi.ch/json.php?mth=upd&res_id={res_id}&res_name={player_name}".format({"res_id": game_id, "player_name": player_name})
	
	if not HttpManager.http_request_completed.is_connected(_on_changed_player_name):
		HttpManager.http_request_completed.connect(_on_changed_player_name)
	HttpManager.make_request(url)
	
	
func send_shock_parameters(game_id: int, shock_id: int, year: int):
	print("shock year ", year)
	var url = "https://sure.euler.usi.ch/json.php?mth=shk&res_id={res_id}&shk_id={shock_id}&yr={yr}".format({"res_id": game_id, "shock_id": shock_id, "yr": year})

	if not HttpManager.http_request_completed.is_connected(_on_shocks_sent_to_model):
		HttpManager.http_request_completed.connect(_on_shocks_sent_to_model)
	HttpManager.make_request(url)


func get_demand_from_context():
	if ctx != null:
		for i in ctx:
			if i["prm_id"] == "455":
				Gameloop.demand_summer = float(i["tj"]) / 100.0
		for i in ctx: # sorry le code est cheum mais j'ai besoin de la demand_summer avant de pouvoir mettre la winter
			if i["prm_id"] == "435":
				Gameloop.demand_winter = (float(i["tj"]) / 100.0) - Gameloop.demand_summer
	else:
		printerr("Context is null")
		printerr("Shock: ", Gameloop.most_recent_shock.title_key)

func _on_got_context_from_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_got_context_from_model):
		HttpManager.http_request_completed.disconnect(_on_got_context_from_model)
		
	_update_context_no_signal(body)

	if ctx!= null and Gameloop.current_turn == 1:
		res_id = int(ctx[0]["res_id"])
		print("getting demand from context")
		get_demand_from_context()
		
	context_updated.emit(ctx)
	

func _on_parameters_sent_to_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_parameters_sent_to_model):
		HttpManager.http_request_completed.disconnect(_on_parameters_sent_to_model)
	
	_update_context_no_signal(body)
	
	parameters_sent_to_model.emit()


func _on_shocks_sent_to_model(_result, _response_code, _headers, _body):
	if HttpManager.http_request_completed.is_connected(_on_shocks_sent_to_model):
		HttpManager.http_request_completed.disconnect(_on_shocks_sent_to_model)
	shocks_sent_to_model.emit()


func _on_got_leaderboard_from_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_got_leaderboard_from_model):
		HttpManager.http_request_completed.disconnect(_on_got_leaderboard_from_model)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	leaderboard_json.append(json.get_data())
	leaderboard_updated.emit(leaderboard_json)


func _on_got_rank_from_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_got_rank_from_model):
		HttpManager.http_request_completed.disconnect(_on_got_rank_from_model)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	rank_json = json.get_data()
	rank_updated.emit(rank_json)
	
	
func _on_changed_player_name(_result, _response_code, _headers, _body):
	if HttpManager.http_request_completed.is_connected(_on_changed_player_name):
		HttpManager.http_request_completed.disconnect(_on_changed_player_name)
	player_name_changed.emit()


func _update_context_no_signal(body):
	context_updated_for_new_turn = true
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	ctx = json.get_data()
