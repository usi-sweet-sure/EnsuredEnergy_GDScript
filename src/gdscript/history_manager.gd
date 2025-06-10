extends Node

var shock_history = {}
var policy_history = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShockManager.shock_resolved.connect(_on_shock_resolved)
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_shock_resolved(shock: Shock):
	if shock != null:
		shock_history[str(Gameloop.current_turn)] = {
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
		shock_history[str(Gameloop.current_turn)]["player_reactions"] = {}
		shock_history[str(Gameloop.current_turn)]["player_reactions"]["chosen_reaction"] = shock.chosen_reaction_index
	
		var index = 0
		for text in shock.player_reactions_texts:
			shock_history[str(Gameloop.current_turn)]["player_reactions"][str(index)] = {}
			shock_history[str(Gameloop.current_turn)]["player_reactions"][str(index)]["key"] = text
			shock_history[str(Gameloop.current_turn)]["player_reactions"][str(index)]["text"] = tr(text)
			index += 1


func _on_policy_voted(_passed: bool):
	var all_voted_polices = PolicyManager.voted_policies
	
	for data in all_voted_polices:
		var policy: Policy = data.policy
		policy_history[str(data.turn)] = {
			"title": {
				"key": policy.title_key,
				"text": tr(policy.title_key)
			},
			"passed": data.passed,
		}
		
		if policy.effects_texts.size() > 0:
			policy_history[str(data.turn)]["effects"] = {}
			
			var index = 0
			for text in policy.effects_texts:
				policy_history[str(data.turn)]["effects"][str(index)] = {
					"key": text,
					"text": tr(text)
				}
				index += 1
