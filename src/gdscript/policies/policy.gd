extends Node

class_name Policy

enum PolicyType {CAMPAIGN, ENVIRONMENTAL, ENERGY}

var policy_type: PolicyType
var inspector_id := "" # This is used so policy buttons nodes can be given a policy in the editor
var title_key := ""
var text_key := ""
var effects: Array[Callable] = []
var effects_texts: Array[String] = [] # Texts for the effects, must match previous array order
var acceptance_probability: float = 0.0: # Probability of the policy to be accepeted by the population, [0,1]
	get:
		var modifier = 0
		if policy_type == PolicyType.ENVIRONMENTAL:
			modifier = PolicyManager.environmental_policies_support
		elif policy_type == PolicyType.ENERGY:
			modifier = PolicyManager.energy_policies_support
			
		return acceptance_probability + modifier



func _init(p_title_key: String, p_text_key: String, p_acceptance_probability: float,
		p_policy_type: PolicyType, p_inspector_id := ""):
	self.title_key = p_title_key
	self.text_key = p_text_key
	self.acceptance_probability = p_acceptance_probability
	self.policy_type = p_policy_type
	self.inspector_id = p_inspector_id


func add_effect(text: String, effect: Callable):
	effects.push_back(effect)
	effects_texts.push_back(text)
	
# returns true if the vote passes
func vote():
	return randf() <= acceptance_probability
	
	
func apply_effects():
	for effect in effects:
		effect.call()
