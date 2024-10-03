extends Node

signal policy_button_clicked
signal vote_button_clicked # Start button for campaigns also call that signal
signal policy_voted
signal personal_support_updated
signal energy_policies_support_updated
signal environmental_policies_support_updated
signal policy_button_unclicked

var environmental_policies_support: float = 0.0: # In [0,1]
	set(new_value):
		environmental_policies_support = new_value
		environmental_policies_support_updated.emit(environmental_policies_support)
var energy_policies_support: float = 0.0: # In [0,1]
	set(new_value):
		energy_policies_support = new_value
		energy_policies_support_updated.emit(energy_policies_support)
var personal_support: float = 0.5: # In [0,1]
	set(new_value):
		personal_support = new_value
		personal_support_updated.emit(personal_support)
var policies: Array[Policy] = []
var last_policy_clicked: Policy
var campaign_is_running = false
var policy_voted_this_turn: Policy = null
# This is an array of the form
# voted_policies = [
#	{
#		"policy" = Policy,
#		"passed" = true,
#		"turn" = 1
#	},
#	{
#		"policy" = Policy,
#		"passed" = false,
#		"turn" = 2
#	},
# ]
var voted_policies: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	policy_button_clicked.connect(_on_policy_button_clicked)
	vote_button_clicked.connect(_on_vote_button_clicked)
	Gameloop.next_turn.connect(_on_next_turn)
	
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
			"POLICIES_ENVIRONMENTAL_POLICY_1_TEXT", 0.8, Policy.PolicyType.ENVIRONMENTAL,
			"ENABLE ALPINE SOLAR PV")
	env_policy_1.add_effect("POLICIES_ENVIRONMENTAL_POLICY_1_EFFECT_1", 
			func(): increase_max_upgrade(3, PowerplantsManager.EngineTypeIds.SOLAR))
			
	var env_policy_2 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_2_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_2_TEXT", 0.6, Policy.PolicyType.ENVIRONMENTAL,
			"FAST TRACK WIND PARKS")
	env_policy_2.add_effect("POLICIES_ENVIRONMENTAL_POLICY_2_EFFECT_1", 
			func(): lower_build_time())
	
	var env_policy_3 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_3_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_3_TEXT", 0.5, Policy.PolicyType.ENVIRONMENTAL, "WIND PARKS REGULATION")		
	env_policy_3.add_effect("POLICIES_ENVIRONMENTAL_POLICY_3_EFFECT_1", 
			func(): increase_max_upgrade(5, PowerplantsManager.EngineTypeIds.WIND))
	
	var energy_policy_1 = Policy.new("POLICIES_ENERGY_POLICY_1_TITLE",
			"POLICIES_ENERGY_POLICY_1_TEXT", 0.7, Policy.PolicyType.ENERGY, "MANDATORY BUILDING INSULATION")
	energy_policy_1.add_effect("POLICIES_ENERGY_POLICY_1_EFFECT_1", 
			func(): lower_household_demand())
	
	var energy_policy_2 = Policy.new("POLICIES_ENERGY_POLICY_2_TITLE",
			"POLICIES_ENERGY_POLICY_2_TEXT", 0.6, Policy.PolicyType.ENERGY, "INDUSTRY SUBSIDY")
	energy_policy_2.add_effect("POLICIES_ENERGY_POLICY_2_EFFECT_1",
			func(): lower_industry_demand())

	policies = [env_campaign, energy_campaign, env_policy_1, env_policy_2, 
			env_policy_3, energy_policy_1, energy_policy_2]


func increase_max_upgrade(new_max: int, type: PowerplantsManager.EngineTypeIds):
	for plant in  get_tree().get_nodes_in_group("Powerplants"):
		if plant.metrics.type == type:
			plant.metrics.max_upgrade = new_max
			plant.metrics_updated.emit(plant.metrics)
	for bb in get_tree().get_nodes_in_group("BbsInConstruction"):
		if bb.metrics != null:
			if bb.metrics.type == type:
				bb.metrics.max_upgrade = new_max
			
	PowerplantsManager.powerplants_max_upgrades[type] = new_max
	PowerplantsManager.powerplants_metrics[type].max_upgrade = new_max
		
				
func lower_build_time():
	var wind_id = PowerplantsManager.EngineTypeIds.WIND
	PowerplantsManager.powerplants_build_times_in_turns[wind_id] = 0
	PowerplantsManager.powerplants_metrics[wind_id].build_time_in_turns = 0
	
	for bb in get_tree().get_nodes_in_group("BbsInConstruction"):
		if bb.metrics != null:
			if bb.metrics.type == wind_id:
				bb.metrics.build_time_in_turns = 0
				bb.powerplant_construction_ended.emit(bb.metrics)
			
				
func lower_industry_demand():
	var industry_demand = 0.0
	for i in Context.ctx:
		if i["prm_id"] == "22":
			industry_demand = float(i["tj"])
	Context.prm_id = 22
	Context.yr = Gameloop.year_list[Gameloop.current_turn] #affects following turn
	Context.tj = -(industry_demand * 5.0 / 100.0)
	Context.send_parameters_to_model()
	
	
func lower_household_demand():
	var household_demand = 0.0
	for i in Context.ctx:
		if i["prm_id"] == "7":
			household_demand = float(i["tj"])
	Context.prm_id = 7
	Context.yr = Gameloop.year_list[Gameloop.current_turn] #affects following turn
	Context.tj = -(household_demand * 5.0 / 100.0)
	Context.send_parameters_to_model()
	
	
func get_policy(inspector_id: String):
	return policies.filter(func(policy): return policy.inspector_id == inspector_id)[0]
	

func _on_policy_button_clicked(policy_id):
	last_policy_clicked = get_policy(policy_id)
	

func _on_vote_button_clicked():
	var vote_passed = last_policy_clicked.vote()
	policy_voted_this_turn = last_policy_clicked
	
	if vote_passed:
		last_policy_clicked.apply_effects()
	
	voted_policies.push_back({
			"policy" = policy_voted_this_turn,
			"passed" = vote_passed,
			"turn" = Gameloop.current_turn
		})
	print("voted policies: ", voted_policies)
	policy_voted.emit(vote_passed)


func _on_next_turn():
	policy_voted_this_turn = null


func did_policy_already_passed(policy: Policy):
	var policy_already_passed = false
	
	for entry in voted_policies:
		var entry_policy: Policy = entry["policy"]
		
		if entry_policy.title_key == policy.title_key and entry["passed"]:
			policy_already_passed = true
			break
	
	return policy_already_passed


func get_turn_of_successful_policy(policy: Policy):
	var turn = -1
	
	for entry in voted_policies:
		var entry_policy: Policy = entry["policy"]
		
		if entry_policy.title_key == policy.title_key and entry["passed"]:
			turn = entry["turn"]
			break
	
	return turn
