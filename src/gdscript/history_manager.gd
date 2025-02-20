extends Node

var shock_history_for_survey = {}
var policy_history_for_survey = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShockManager.shock_resolved.connect(_on_shock_resolved)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_shock_resolved(shock: Shock):
	if shock != null:
		shock_history_for_survey[str(Gameloop.current_turn)] = {
				"shock_title": {
					"key" : shock.title_key,
					"text" : tr(shock.title_key),
				},
				"shock_effect": {
					"key": shock.text_key,
					"text": tr(shock.text_key)
				},
			}
		
	
	if shock.player_reactions_texts.size() > 0:
		shock_history_for_survey[str(Gameloop.current_turn)]["player_reactions"] = {}
		shock_history_for_survey[str(Gameloop.current_turn)]["player_reactions"]["chosen_reaction"] = shock.chosen_reaction_index
	
		var index = 0
		for text in shock.player_reactions_texts:
			shock_history_for_survey[str(Gameloop.current_turn)]["player_reactions"][str(index)] = {}
			shock_history_for_survey[str(Gameloop.current_turn)]["player_reactions"][str(index)]["key"] = text
			shock_history_for_survey[str(Gameloop.current_turn)]["player_reactions"][str(index)]["text"] = tr(text)
			index += 1
			
	send_history_to_survey()


func _on_policy_voted(_passed: bool):
	var all_voted_polices = PolicyManager.voted_policies
	
	for data in all_voted_polices:
		var policy: Policy = data.policy
		policy_history_for_survey[str(data.turn)] = {
			"title": {
				"key": policy.title_key,
				"text": tr(policy.title_key)
			},
			"passed": data.passed,
		}
		
		if policy.effects_texts.size() > 0:
			policy_history_for_survey[str(data.turn)]["effects"] = {}
			
			var index = 0
			for text in policy.effects_texts:
				policy_history_for_survey[str(data.turn)]["effects"][str(index)] = {
					"key": text,
					"text": tr(text)
				}
				index += 1
		
	send_history_to_survey()

func get_shock_event(shock_title: String):
	var shock_event = null
	for turn in shock_history_for_survey:
		var shock_data = shock_history_for_survey[turn]
		var title = shock_data["shock_title"]["key"]
		
		if title == shock_title:
			shock_event = shock_data
			
	return shock_event


func send_history_to_survey():
	var url = "https://sure.euler.usi.ch/json.php?mth=upd2"
	var data_to_send = {
		"res_id": Context.res_id,
		"res_txt": {
			"shocks" : shock_history_for_survey,
			"policies": policy_history_for_survey
		}
	}
		
	HttpManager.send_history(url, data_to_send)
