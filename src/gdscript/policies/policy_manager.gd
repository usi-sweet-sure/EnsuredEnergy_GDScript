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
			"POLICIES_ENVIRONMENTAL_POLICY_1_TEXT", 0.8, Policy.PolicyType.ENVIRONMENTAL,
			"ENABLE ALPINE SOLAR PV")
	env_policy_1.add_effect("POLICIES_ENVIRONMENTAL_POLICY_1_EFFECT_1", 
			func(): increase_max_upgrade(3, "SOLAR"))
			
	var env_policy_2 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_2_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_2_TEXT", 0.6, Policy.PolicyType.ENVIRONMENTAL,
			"FAST TRACK WIND PARKS")
	env_policy_2.add_effect("POLICIES_ENVIRONMENTAL_POLICY_2_EFFECT_1", 
			func(): lower_build_time())
	
	var env_policy_3 = Policy.new("POLICIES_ENVIRONMENTAL_POLICY_3_TITLE",
			"POLICIES_ENVIRONMENTAL_POLICY_3_TEXT", 0.5, Policy.PolicyType.ENVIRONMENTAL, "WIND PARKS REGULATION")		
	env_policy_3.add_effect("POLICIES_ENVIRONMENTAL_POLICY_3_EFFECT_1", 
			func(): increase_max_upgrade(5, "WIND"))
	
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

func increase_max_upgrade(new_max: int, name: String):
	for plant in  get_tree().get_nodes_in_group("PP"):
		if plant.plant_name == name:
			plant.max_upgrade = new_max
			plant._update_info()
	for bb in get_tree().get_nodes_in_group("BB"):
		for plant in bb.powerplants:
			if plant.plant_name == name:
				plant.max_upgrade = new_max
				plant._update_info()
				
func lower_build_time():
	for bb in get_tree().get_nodes_in_group("BB"):
		for plant in bb.build_menu_plants:
			if plant.plant_name == "WIND":
				plant.build_time = 0
				plant._update_info()
		if bb.building_plant != null:
			if bb.building_plant.plant_name == "WIND":
				bb._build_plant(bb.building_plant, false)
				
func lower_industry_demand():
	var industry_demand = 0.0
	for i in Context1.ctx1:
		if i["prm_id"] == "22":
			industry_demand = float(i["tj"])
	Context1.prm_id = 22
	Context1.yr = Gameloop.year_list[Gameloop.current_turn] #affects following turn
	Context1.tj = -(industry_demand * 5.0 / 100.0)
	Context1.prm_ups()
	
func lower_household_demand():
	var household_demand = 0.0
	for i in Context1.ctx1:
		if i["prm_id"] == "7":
			household_demand = float(i["tj"])
	Context1.prm_id = 7
	Context1.yr = Gameloop.year_list[Gameloop.current_turn] #affects following turn
	Context1.tj = -(household_demand * 5.0 / 100.0)
	Context1.prm_ups()
	
	
	

func get_policy(inspector_id: String):
	return policies.filter(func(policy): return policy.inspector_id == inspector_id)[0]
	

func _on_policy_button_clicked(policy_id):
	last_policy_clicked = get_policy(policy_id)
	

func _on_vote_button_clicked():
	var vote_passed = last_policy_clicked.vote()
	
	if vote_passed:
		last_policy_clicked.apply_effects()

	policy_voted.emit(vote_passed)
