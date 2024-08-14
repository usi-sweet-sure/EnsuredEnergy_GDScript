extends Node

signal policy_button_clicked
signal vote_button_clicked # Start button for campaigns also call that signal
signal policy_voted
signal personal_support_updated

var environmental_policies_support: float = 0.0 # In [0,1]
var energy_policies_support: float = 0.0 # In [0,1]
var personal_support: float = 0.5: # In [0,1]
	set(new_value):
		personal_support = new_value
		personal_support_updated.emit(personal_support)
var policies: Array[Policy] = []
var last_policy_clicked: Policy

# Called when the node enters the scene tree for the first time.
func _ready():
	policy_button_clicked.connect(_on_policy_button_clicked)
	vote_button_clicked.connect(_on_vote_button_clicked)
	
	# Campaigns are treated as policies than don't need a vote
	var env_campaign = Policy.new("POLICIES_ENVIRONMENTAL_CAMPAIGN_TITLE",
			"POLICIES_ENVIRONMENTAL_CAMPAIGN_TEXT", 1, Policy.PolicyType.CAMPAIGN,
			"ENVIRONMENTAL CAMPAIGN")
	env_campaign.add_effect("POLICIES_ENVIRONMENTAL_CAMPAIGN_EFFECT",
			func(): PolicyManager.environmental_policies_support += 0.1)
	
	var energy_campaign = Policy.new("POLICIES_ENERGY_CAMPAIGN_TITLE",
			"POLICIES_ENERGY_CAMPAIGN_TEXT", 1, Policy.PolicyType.CAMPAIGN, "ENERGY CAMPAIGN")
	energy_campaign.add_effect("POLICIES_ENERGY_CAMPAIGN_EFFECT",
			func(): PolicyManager.energy_policies_support += 0.1)
	
	var env_policy_1 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_1_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_1_TEXT", 0.6, Policy.PolicyType.ENVIRONMENTAL,
			"ENABLE ALPINE SOLAR PV")
	env_policy_1.add_effect("POLICIES_ENVIRONMENTAL_POLICY_1_EFFECT_1", 
			func(): print("upgrade solar plant upgrades from 1 to 3")) # E. Implement
			
	var env_policy_2 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_2_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_2_TEXT", 0.5, Policy.PolicyType.ENVIRONMENTAL,
			"FAST TRACK WIND PARKS")
	env_policy_2.add_effect("POLICIES_ENVIRONMENTAL_POLICY_2_EFFECT_1", 
			func(): print("Lower required building time for wind parks from 2 to 0 turns")) # E. Implement
	
	var env_policy_3 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_3_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_3_TEXT", 0.4, Policy.PolicyType.ENVIRONMENTAL, "WIND PARKS REGULATION")		
	env_policy_3.add_effect("POLICIES_ENVIRONMENTAL_POLICY_3_EFFECT_1", 
			func(): print("Increase wind parks upgrades from 2 to 5.")) # E. Implement
	
	var energy_policy_1 = Policy.new("POLICIES_ENERGY_POLICY_1_TITLE",
			"POLICIES_ENERGY_POLICY_1_TEXT", 0.5, Policy.PolicyType.ENERGY, "MANDATORY BUILDING INSULATION")
	energy_policy_1.add_effect("POLICIES_ENERGY_POLICY_1_EFFECT_1", 
			func(): print("Lower energy demand in summer by 5")) # E. Implement
	energy_policy_1.add_effect("POLICIES_ENERGY_POLICY_1_EFFECT_2", 
			func(): print("Lower energy demand in winter by 5")) # E. Implement
	
	var energy_policy_2 = Policy.new("POLICIES_ENERGY_POLICY_2_TITLE",
			"POLICIES_ENERGY_POLICY_2_TEXT", 0.3, Policy.PolicyType.ENERGY, "INDUSTRY SUBSIDY")
	energy_policy_2.add_effect("POLICIES_ENERGY_POLICY_2_EFFECT_1", 
			func(): print("Lower energy demand in summer by 5")) # E. Implement
	energy_policy_2.add_effect("POLICIES_ENERGY_POLICY_2_EFFECT_2", 
			func(): print("Lower energy demand in winter by 5")) # E. Implement

	policies = [env_campaign, energy_campaign, env_policy_1, env_policy_2, 
			env_policy_3, energy_policy_1, energy_policy_2]


func get_policy(inspector_id: String):
	return policies.filter(func(policy): return policy.inspector_id == inspector_id)[0]
	

func _on_policy_button_clicked(policy_id):
	last_policy_clicked = get_policy(policy_id)
	

func _on_vote_button_clicked():
	var vote_passed = last_policy_clicked.vote()
	
	if vote_passed:
		last_policy_clicked.apply_effects()

	policy_voted.emit(vote_passed)
