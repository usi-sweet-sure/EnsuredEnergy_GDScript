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
	if Gameloop.use_remote_model:
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
			pass
			#printerr("A res_name is needed (Player's name is probably missing)")
	else:
		var custom_res_id = "1"
		var custom_year = "2022"
		var body = [
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "151", "tj": "243284.2380952381" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "162", "tj": "63111.1716796875" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "163", "tj": "82995.43783482144" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "186", "tj": "7211.047619047618" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "189", "tj": "50219.04761904762" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "192", "tj": "5564.1562120710105" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "175", "tj": "4261.027029273624" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "170", "tj": "8277.64766918364" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "171", "tj": "640.3790076437451" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "774", "tj": "0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "152", "tj": "80285.64129008474" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "160", "tj": "63111.1716796875" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "161", "tj": "69109.15278076196" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "168", "tj": "8277.64766918364" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "169", "tj": "640.3790076437451" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "173", "tj": "1225.6265220783616" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "187", "tj": "1275.5450402367262" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "190", "tj": "8883.127521006874" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "193", "tj": "1347.6771721222447" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "252", "tj": "0.9461053587622787" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "253", "tj": "0.0701235263031333" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "254", "tj": "1.2018412569692978" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "255", "tj": "0.09764814695006949" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "256", "tj": "0.07109755036489553" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "257", "tj": "0.4107156604054101" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "258", "tj": "0.1862470753801118" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "259", "tj": "0.00302401183943346" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "282", "tj": "8.785264472376488" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "283", "tj": "2.6296321251564008" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "284", "tj": "0.6810434069318164" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "285", "tj": "0.6974867802411955" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "286", "tj": "19.474547343363355" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "287", "tj": "0.18937898118427945" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "288", "tj": "0.6898039650440249" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "289", "tj": "0.3735544078059308" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "322", "tj": "6082.106043011394" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "323", "tj": "1402.4703981770783" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "324", "tj": "320.49098618825275" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "325", "tj": "1255.4762091842435" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "326", "tj": "370.9437253614304" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "327", "tj": "248.55989522563627" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "328", "tj": "229.93465919047003" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "329", "tj": "23.12479611990101" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "458", "tj": "0.276651458750927" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "459", "tj": "94.52258136877083" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "460", "tj": "1844.3429530646188" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "525", "tj": "-0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "526", "tj": "0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "332", "tj": "37772.39331845384" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "333", "tj": "37099.08813961933" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "461", "tj": "36480.96973718526" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "338", "tj": "6242.445674227538" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "339", "tj": "242.8310590902427" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "337", "tj": "612.8132610391808" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "334", "tj": "637.7725201183631" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "335", "tj": "4441.563760503437" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "336", "tj": "673.8385860611223" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "7", "tj": "70492.11904761904" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "22", "tj": "61519.21428571428" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "435", "tj": "225201.50827236683" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "455", "tj": "104423.01176628895" }]
		
		_on_got_context_from_model(null, null, null, body)

#upsert param
func send_parameters_to_model(game_id: int, year: int, prm_id: int, tj: float):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}".format({"res_id": game_id, "yr": year, "prm_id": prm_id, "tj": tj})
		
		if not HttpManager.http_request_completed.is_connected(_on_parameters_sent_to_model):
			HttpManager.http_request_completed.connect(_on_parameters_sent_to_model)
		HttpManager.make_request(url)
	else:
		_on_parameters_sent_to_model()
	

func get_context_from_model(game_id: int, year: int):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}".format({"res_id": game_id, "yr": year})
		
		if not HttpManager.http_request_completed.is_connected(_on_got_context_from_model):
			HttpManager.http_request_completed.connect(_on_got_context_from_model)
		HttpManager.make_request(url)
	else:
		#!! local_model
		# This function is only called on a new turn, just after shock effect are applied.
		# The shocks know how to update the model, so ctx should be modified
		# in the shock code, not here.
		var body = ctx
		_on_got_context_from_model(null, null, null, body)
	
	
func get_leaderboard_from_model(category: String):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=lst&lim=5&ord={category}".format({"category": category})
		
		if not HttpManager.http_request_completed.is_connected(_on_got_leaderboard_from_model):
			HttpManager.http_request_completed.connect(_on_got_leaderboard_from_model)
		HttpManager.make_request(url)
		
		
func get_rank(game_id: int):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=rnk&res_id={res_id}".format({"res_id": game_id})
		
		if not HttpManager.http_request_completed.is_connected(_on_got_rank_from_model):
			HttpManager.http_request_completed.connect(_on_got_rank_from_model)
		HttpManager.make_request(url)
	
	
func change_player_name(game_id: int, player_name: String):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=upd&res_id={res_id}&res_name={player_name}".format({"res_id": game_id, "player_name": player_name})
		
		if not HttpManager.http_request_completed.is_connected(_on_changed_player_name):
			HttpManager.http_request_completed.connect(_on_changed_player_name)
		HttpManager.make_request(url)
	
	
func send_shock_parameters(game_id: int, shock_id: int, year: int):
	if Gameloop.use_remote_model:
		var url = "https://sure.euler.usi.ch/json.php?mth=shk&res_id={res_id}&shk_id={shock_id}&yr={yr}".format({"res_id": game_id, "shock_id": shock_id, "yr": year})

		if not HttpManager.http_request_completed.is_connected(_on_shocks_sent_to_model):
			HttpManager.http_request_completed.connect(_on_shocks_sent_to_model)
		HttpManager.make_request(url)
	else:
		# !! local_model
		# Change ctx according to the shock id
		var body = ctx
		_on_shocks_sent_to_model(null, null, null, body)


func get_demand_from_context():
	if ctx != null:
		for i in ctx:
			if i["prm_id"] == "455":
				Gameloop.demand_summer = float(i["tj"]) / 100.0
		for i in ctx: # sorry le code est cheum mais j'ai besoin de la demand_summer avant de pouvoir mettre la winter
			if i["prm_id"] == "435":
				Gameloop.demand_winter = (float(i["tj"]) / 100.0) - Gameloop.demand_summer
	else:
		pass
		#printerr("Context is null")
		#printerr("Shock: ", Gameloop.most_recent_shock.title_key)


func _on_got_context_from_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_got_context_from_model):
		HttpManager.http_request_completed.disconnect(_on_got_context_from_model)
		
	_update_context_no_signal(body)

	if ctx!= null and Gameloop.current_turn == 1:
		res_id = int(ctx[0]["res_id"])
		get_demand_from_context()

	context_updated.emit(ctx)
	

func _on_parameters_sent_to_model(_result = null, _response_code = null, _headers = null, body = null):
	if HttpManager.http_request_completed.is_connected(_on_parameters_sent_to_model):
		HttpManager.http_request_completed.disconnect(_on_parameters_sent_to_model)
	
	if not Gameloop.use_remote_model:
		# !! local_model
		# There seems to be no need to change the year, but
		# if needed, the model normaly returns the year for the
		# turn starting just after the params where sent.
		# Nothing changes except for prm_id 435 and 455, which are
		# the winter and summer demand. Numbers from the model did not change that
		# much, so I kept the same numbers for now
		var custom_res_id = "1"
		var custom_year = "2022"
		body = [
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "151", "tj": "243284.2380952381" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "162", "tj": "63111.1716796875" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "163", "tj": "82995.43783482144" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "186", "tj": "7211.047619047618" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "189", "tj": "50219.04761904762" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "192", "tj": "5564.1562120710105" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "175", "tj": "4261.027029273624" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "170", "tj": "8277.64766918364" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "171", "tj": "640.3790076437451" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "774", "tj": "0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "152", "tj": "80285.64129008474" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "160", "tj": "63111.1716796875" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "161", "tj": "69109.15278076196" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "168", "tj": "8277.64766918364" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "169", "tj": "640.3790076437451" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "173", "tj": "1225.6265220783616" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "187", "tj": "1275.5450402367262" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "190", "tj": "8883.127521006874" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "193", "tj": "1347.6771721222447" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "252", "tj": "0.9461053587622787" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "253", "tj": "0.0701235263031333" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "254", "tj": "1.2018412569692978" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "255", "tj": "0.09764814695006949" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "256", "tj": "0.07109755036489553" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "257", "tj": "0.4107156604054101" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "258", "tj": "0.1862470753801118" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "259", "tj": "0.00302401183943346" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "282", "tj": "8.785264472376488" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "283", "tj": "2.6296321251564008" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "284", "tj": "0.6810434069318164" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "285", "tj": "0.6974867802411955" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "286", "tj": "19.474547343363355" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "287", "tj": "0.18937898118427945" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "288", "tj": "0.6898039650440249" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "289", "tj": "0.3735544078059308" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "322", "tj": "6082.106043011394" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "323", "tj": "1402.4703981770783" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "324", "tj": "320.49098618825275" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "325", "tj": "1255.4762091842435" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "326", "tj": "370.9437253614304" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "327", "tj": "248.55989522563627" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "328", "tj": "229.93465919047003" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "329", "tj": "23.12479611990101" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "458", "tj": "0.276651458750927" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "459", "tj": "94.52258136877083" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "460", "tj": "1844.3429530646188" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "525", "tj": "-0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "526", "tj": "0" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "332", "tj": "37772.39331845384" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "333", "tj": "37099.08813961933" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "461", "tj": "36480.96973718526" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "338", "tj": "6242.445674227538" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "339", "tj": "242.8310590902427" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "337", "tj": "612.8132610391808" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "334", "tj": "637.7725201183631" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "335", "tj": "4441.563760503437" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "336", "tj": "673.8385860611223" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "7", "tj": "70492.11904761904" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "22", "tj": "61519.21428571428" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "435", "tj": "225201.50827236683" },
			{ "res_id": custom_res_id, "yr": custom_year, "prm_id": "455", "tj": "104423.01176628895" }]
		
	_update_context_no_signal(body)
	
	
	parameters_sent_to_model.emit()


func _on_shocks_sent_to_model(_result, _response_code, _headers, body):
	if HttpManager.http_request_completed.is_connected(_on_shocks_sent_to_model):
		HttpManager.http_request_completed.disconnect(_on_shocks_sent_to_model)
		
	_update_context_no_signal(body)
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
	
	if Gameloop.use_remote_model:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		
		var data = json.get_data()
		
		if data != null:
			ctx = data
	else:
		ctx = body
		
	get_demand_from_context()
