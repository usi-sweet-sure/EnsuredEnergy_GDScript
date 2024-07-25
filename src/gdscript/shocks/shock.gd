extends Node

class_name Shock

var show_shock_window := true
var title_key := ""
var text_key := ""
var img := ""
var requirements_met_text_key := "" # Requirement to absorb the shock
var conditions_to_meet_requirements: Array[Callable] = [] # Conditions to meet the requirement, must return boolean
var requirements_met_effects: Array[Callable] = [] # Effect of meeting the requirement
var effects: Array[Callable] = [] # Effects of the shock
var player_reactions: Array[Callable]  = [] # Options given to the player to react to the shock
var player_reactions_texts: Array[String] = [] # Texts for the options, must match previous array order


func _init(p_title_key:String,p_text_key: String, p_img: String, p_show_shock_window := true):
	self.title_key = p_title_key
	self.text_key = p_text_key
	self.img = p_img
	self.show_shock_window = p_show_shock_window


func apply():
	if _are_requirements_to_absorb_shock_met():
		_apply_requirements_met_effects()
	
	_apply_effects()
	

func apply_reaction(reaction_index: int):
	if(player_reactions.size() > reaction_index):
		player_reactions[reaction_index].call()
		

func add_effect(effect: Callable):
	self.effects.push_back(effect)


func add_requirements(p_requirements_met_text_key: String, p_conditions_to_meet_requirements: Array[Callable], p_requirements_met_effects: Array[Callable]):
	self.requirements_met_text_key = p_requirements_met_text_key
	self.conditions_to_meet_requirements = p_conditions_to_meet_requirements
	self.requirements_met_effects = p_requirements_met_effects
	

func add_player_reaction(text: String, effect: Callable):
	player_reactions.push_back(effect)
	player_reactions_texts.push_back(text)
	

func _are_requirements_to_absorb_shock_met():
	var conditions_met := true;
	print("testing requirements")
	
	if conditions_to_meet_requirements.size() == 0:
		conditions_met = false
	else:
		for i in conditions_to_meet_requirements.size():
			conditions_met = conditions_to_meet_requirements[i].call()
			if not conditions_met:
				break
		
	print("conditions met ? ", conditions_met)
	return conditions_met
	
	
func _apply_requirements_met_effects():
	print("applying requirement met effects")
	for effect in requirements_met_effects:
		effect.call()


func _apply_effects():
	print("applying effects")
	for effect in effects:
		effect.call()
