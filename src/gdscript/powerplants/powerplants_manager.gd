extends Node

# All empty map emplacements listen to this, but will only build if they are
# the node passed in the parameters
signal powerplant_build_requested(map_emplacement: PpMapEmplacement, metrics: PowerplantMetrics)
# The 3 signals below are used by the 3 concerned node types so they can update their focus state
signal build_button_normal_toggled(toggled_on: bool, target_map_emplacement: PpMapEmplacement, can_build: Array[EngineTypeIds])
signal build_button_in_construction_toggled(toggled_on: bool, target_map_emplacement: PpMapEmplacement)
signal pp_scene_toggled(toggled_on: bool, pp_scene: PpScene)
signal carbon_sequestration_toggled(toggled_on: bool)
signal hide_build_menu
signal powerplants_metrics_updated(metrics: Array[PowerplantMetrics])


# Ids used to identify the powerplants inside the engine in a consistent manner
enum EngineTypeIds {
	SOLAR,
	WIND,
	GAS,
	WASTE,
	BIOMASS,
	BIOGAS,
	NUCLEAR,
	CARBON_SEQUESTRATION,
	HYDRO,
	RIVER,
}

# Stores the base data of the powerplants, some of this is retrieved from the model,
# some are local to the engine.
# Each powerplant type data is stored at the index corresponding to EngineTypeIds.
# MUST BE in the same order as EngineTypeIds.
var powerplants_metrics: Array[PowerplantMetrics] = []

# Used to revert changes made to metrics by a shock
var metrics_backup: Array[PowerplantMetrics] = []

# Used by all the types. Texture is set at runtime when the scene is instantiated
var powerplant_scene = preload("res://scenes/powerplants/pp_map_emplacement/pp_scene.tscn")

# Effects when the powerplants are on. They are overlayed on the powerplant scene
# MUST BE in the same order as EngineTypeIds
var powerplants_effects: Array[String] = [
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/solar/pp_effects_solar.tscn", # Solar
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/wind/pp_effects_wind.tscn", # Wind
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/gas/pp_effects_gas.tscn", # Gas
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/waste/pp_effects_waste.tscn", # Waste
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/biomass/pp_effects_biomass.tscn", # Biomass
	"", # Biogas
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/nuclear/pp_effects_nuclear.tscn", # Nuclear
	"", # Carbon sequestration
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/hydro/pp_effects_hydro.tscn", # Hydro
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/river/pp_effects_river.tscn", # River 
] 

# First dimension MUST BE in the same order as EngineTypeIds
# Second dimension in upgrades order
var powerplants_textures_on: Array[Array] = [
	# Solar
	["res://assets/textures/powerplants/pp_sprite_on_solar.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_1.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_2.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_3.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_4.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_5.png",
	 "res://assets/textures/powerplants/pp_sprite_on_solar_6.png"],
	# Wind
	["res://assets/textures/powerplants/pp_sprite_on_wind.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_1.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_2.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_3.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_4.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_5.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_6.png",],
	# Gas
	["res://assets/textures/powerplants/pp_sprite_on_gas.png"],
	# Waste
	["res://assets/textures/powerplants/pp_sprite_on_waste.png"],
	# Biomass
	["res://assets/textures/powerplants/pp_sprite_on_biomass.png"],
	# Biogas
	["res://assets/textures/powerplants/pp_sprite_on_biogas.png"],
	# Nuclear
	["res://assets/textures/powerplants/pp_sprite_on_nuclear.png"],
	# Carbon sequestration
	["res://assets/textures/powerplants/pp_sprite_on_carbon_sequestration.png"],
	# Hydro
	["res://assets/textures/powerplants/pp_sprite_on_hydro.png"],
	# River 
	["res://assets/textures/powerplants/pp_sprite_on_river.png"],
]

# First dimension MUST BE in the same order as EngineTypeIds
# Second dimension in upgrades order
var powerplants_textures_off: Array[Array] = [
	# Solar
	["res://assets/textures/powerplants/pp_sprite_off_solar.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_1.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_2.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_3.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_4.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_5.png",
	 "res://assets/textures/powerplants/pp_sprite_off_solar_6.png"],
	# Wind
	["res://assets/textures/powerplants/pp_sprite_off_wind.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_1.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_2.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_3.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_4.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_5.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_6.png",], 
	# Gas
	["res://assets/textures/powerplants/pp_sprite_off_gas.png"],
	# Waste
	["res://assets/textures/powerplants/pp_sprite_off_waste.png"],
	# Biomass
	["res://assets/textures/powerplants/pp_sprite_off_biomass.png"],
	# Biogas
	["res://assets/textures/powerplants/pp_sprite_off_biogas.png"],
	# Nuclear
	["res://assets/textures/powerplants/pp_sprite_off_nuclear.png"],
	# Carbon sequestration
	["res://assets/textures/powerplants/pp_sprite_off_carbon_sequestration.png"],
	# Hydro
	["res://assets/textures/powerplants/pp_sprite_off_hydro.png"],
	# River 
	["res://assets/textures/powerplants/pp_sprite_off_river.png"],
]

# MUST BE in the same order as EngineTypeIds
var powerplants_textures_neon: Array[String] = [
	"res://assets/textures/powerplants/pp_sprite_neon_solar.png", # Solar
	"res://assets/textures/powerplants/pp_sprite_neon_wind.png", # Wind
	"res://assets/textures/powerplants/pp_sprite_neon_gas.png", # Gas
	"res://assets/textures/powerplants/pp_sprite_neon_waste.png", # Waste
	"res://assets/textures/powerplants/pp_sprite_neon_biomass.png", # Biomass
	"res://assets/textures/powerplants/pp_sprite_neon_biogas.png", # Biogas
	"res://assets/textures/powerplants/pp_sprite_neon_nuclear.png", # Nuclear
	"res://assets/textures/powerplants/pp_sprite_neon_carbon_sequestration.png", # Carbon sequestration
	"res://assets/textures/powerplants/pp_sprite_neon_hydro.png", # Hydro
	"res://assets/textures/powerplants/pp_sprite_neon_river.png", # River 
]

# MUST BE in the same order as EngineTypeIds
var powerplants_build_times_in_turns: Array[int] = [
	0, # Solar
	2, # Wind
	0, # Gas
	0, # Waste
	0, # Biomass
	0, # Biogas
	0, # Nuclear
	0, # Carbon sequestration
	6, # Hydro
	3, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_life_spans_in_turns: Array[int] = [
	11, # Solar
	11, # Wind
	11, # Gas
	11, # Waste
	11, # Biomass
	11, # Biogas
	11, # Nuclear
	11, # Carbon sequestration
	11, # Hydro
	11, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_max_upgrades: Array[int] = [
	6, # Solar
	6, # Wind
	3, # Gas
	3, # Waste
	9, # Biomass
	9, # Biogas
	0, # Nuclear
	3, # Carbon sequestration
	9, # Hydro
	9, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_min_upgrades: Array[int] = [
	0, # Solar
	0, # Wind
	0, # Gas
	0, # Waste
	0, # Biomass
	0, # Biogas
	0, # Nuclear
	0, # Carbon sequestration
	0, # Hydro
	0, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_factors_for_production_costs: Array[float] = [
	0.2, # Solar
	0.5, # Wind
	0.5, # Gas
	0.25, # Waste
	0.25, # Biomass
	0.25, # Biogas
	0.1, # Nuclear
	0.5, # Carbon sequestration
	0.02, # Hydro
	0.02, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_factors_for_emissions: Array[float] = [
	0.2, # Solar
	0.5, # Wind
	0.5, # Gas
	0.25, # Waste
	0.25, # Biomass
	0.25, # Biogas
	0.1, # Nuclear
	0.5, # Carbon sequestration
	0.02, # Hydro
	0.02, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_factors_for_land_use: Array[float] = [
	0.2, # Solar
	0.5, # Wind
	0.5, # Gas
	0.25, # Waste
	0.25, # Biomass
	0.25, # Biogas
	0.1, # Nuclear
	0.5, # Carbon sequestration
	0.02, # Hydro
	0.02, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_factors_for_winter_supply: Array[float] = [
	0.2, # Solar
	0.5, # Wind
	0.5, # Gas
	0.25, # Waste
	0.25, # Biomass
	0.25, # Biogas
	0.1, # Nuclear
	0.5, # Carbon sequestration
	0.02, # Hydro
	0.02, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_factors_for_summer_supply: Array[float] = [
	0.2, # Solar
	0.5, # Wind
	0.5, # Gas
	0.25, # Waste
	0.25, # Biomass
	0.25, # Biogas
	0.1, # Nuclear
	0.5, # Carbon sequestration
	0.02, # Hydro
	0.02, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_can_upgrade: Array[bool] = [
	true, # Solar
	true, # Wind
	false, # Gas
	false, # Waste
	true, # Biomass
	true, # Biogas
	false, # Nuclear
	true, # Carbon sequestration
	true, # Hydro
	true, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_upgrade_costs: Array[float] = [
	10, # Solar
	5, # Wind
	25, # Gas
	25, # Waste
	20, # Biomass
	15, # Biogas
	25, # Nuclear
	25, # Carbon sequestration
	30, # Hydro
	25, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_production_cost_factors: Array[float] = [
	1.0 / 4.0, # Solar
	1.0, # Wind
	1.0, # Gas
	1.0 / 4.0, # Waste
	1.2, # Biomass
	1.0, # Biogas
	1.0 / 3.0, # Nuclear
	1.0, # Carbon sequestration
	1.0 / 4.0, # Hydro
	1.0 / 4.0, # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_model_id = [
	"168", # Solar
	"169", # Wind
	"187", # Gas
	"190", # Waste
	"193", # Biomass
	"173", # Biogas
	"152", # Nuclear
	"774", # Carbon sequestration
	"161", # Hydro
	"160", # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_ups_id = [
	"170", # Solar
	"171", # Wind
	"186", # Gas
	"189", # Waste
	"192", # Biomass
	"175", # Biogas
	"151", # Nuclear
	"774", # Carbon sequestration
	"163", # Hydro
	"162", # River
]

# MUST BE in the same order as EngineTypeIds
var powerplants_metrics_id = [
	{ # Solar
		"production_cost": "328",
		"emission": "258",
		"land_use": "288",
		"availability": "338",
	},
	{ # Wind
		"production_cost": "329",
		"emission": "259",
		"land_use": "289",
		"availability": "339",
	},
	{ # Gas
		"production_cost": "324",
		"emission": "254",
		"land_use": "284",
		"availability": "334",
	},	
	{ # Waste
		"production_cost": "325",
		"emission": "255",
		"land_use": "285",
		"availability": "335",
	},
	{ # Biomass
		"production_cost": "326",
		"emission": "256",
		"land_use": "286",
		"availability": "336",
	},
	{ # Biogas
		"production_cost": "327",
		"emission": "257",
		"land_use": "287",
		"availability": "337",
	},
	{ # Nuclear
		"production_cost": "322",
		"emission": "252",
		"land_use": "282",
		"availability" : "332",
	},
	{ # Carbon sequestration
		"production_cost": "526",
		"emission": "525",
		"land_use": "",
		"availability": "",
	},
	{ # Hydro
		"production_cost": "460",
		"emission": "458",
		"land_use": "459",
		"availability": "461",
	},
	{ # River
		"production_cost": "323",
		"emission": "253",
		"land_use": "283",
		"availability": "333",
	},
]


func _ready():
	Context.context_updated.connect(_on_context_updated)


func _on_context_updated(context):
	if context != null:
		powerplants_metrics = []
		
		for type in EngineTypeIds.values():
			# Makes room for the upcoming metrics, since it will be stored by
			# indexing the array instead of pushing back
			powerplants_metrics.push_back(null) 
			_store_powerplant_metrics(type)
			
		powerplants_metrics_updated.emit(powerplants_metrics)
		Context.context_updated.disconnect(_on_context_updated)
		Gameloop.player_can_start_playing_first_turn.emit()


func _store_powerplant_metrics(engine_type_id: EngineTypeIds):
	var model_key: String = powerplants_model_id[engine_type_id]
	var plant_id: String = powerplants_ups_id[engine_type_id]
	var emission_key: String = powerplants_metrics_id[engine_type_id]["emission"]
	var land_use_key: String = powerplants_metrics_id[engine_type_id]["land_use"]
	var production_cost_key: String = powerplants_metrics_id[engine_type_id]["production_cost"]
	var availability_key: String = powerplants_metrics_id[engine_type_id]["availability"]
	
	var capacity := 0.0
	var cnv_capacity := 0.0
	var emissions := 0.0
	var land_use := 0.0
	var production_cost := 0.0
	var availability := Vector2(0.0, 0.0)
	var building_costs := 0.0
	var build_time_in_turns = powerplants_build_times_in_turns[engine_type_id]
	var life_span_in_turns = powerplants_life_spans_in_turns[engine_type_id]
	
	if Context.ctx != null:
		for i in Context.ctx:
			match i["prm_id"]:
				model_key:
					capacity = float(i["tj"])
				plant_id:
					cnv_capacity = float(i["tj"])
				emission_key:
					emissions = float(i["tj"])
				land_use_key:
					land_use = float(i["tj"])
				production_cost_key:
					production_cost = float(i["tj"]) / 10.0
					building_costs = production_cost
				availability_key:
					availability.x = float(i["tj"]) / capacity
					availability.y = 1 - availability.x
	
	if engine_type_id == EngineTypeIds.NUCLEAR:
		cnv_capacity = cnv_capacity / 3.0
		capacity = capacity / 100.0 / 3.0 # there's 3 nuclear plants
		emissions /= 3.0
		land_use /= 3.0
		#production_cost = production_cost / 3.0
	elif engine_type_id == EngineTypeIds.HYDRO || engine_type_id == EngineTypeIds.RIVER:
		cnv_capacity = cnv_capacity / 2.0
		capacity = capacity / 100.0 / 2.0
		emissions /= 4.0 # needs to divide by the number of water plants
		land_use /= 4.0
		#production_cost = production_cost / 4.0
	elif engine_type_id == EngineTypeIds.SOLAR || engine_type_id == EngineTypeIds.WASTE:
		cnv_capacity = cnv_capacity / 4.0
		capacity = capacity / 100.0 / 4.0
		emissions /= 4.0 # needs to divide by the number of water plants
		land_use /= 4.0
		#production_cost = production_cost / 4.0
	else:
		capacity /= 100.0
		
	production_cost *= powerplants_production_cost_factors[engine_type_id]
	
	var can_activate = true
	var active = false
	var can_delete = true
	var construction_started_on_turn = 0
	var built_on_turn = 0
	var current_upgrade = 0
	var min_upgrade = powerplants_min_upgrades[engine_type_id]
	var max_upgrade = powerplants_max_upgrades[engine_type_id]
	var upgrade_factor_for_production_costs = powerplants_upgrade_factors_for_production_costs[engine_type_id]
	var upgrade_factor_for_emissions = powerplants_upgrade_factors_for_emissions[engine_type_id]
	var upgrade_factor_for_land_use = powerplants_upgrade_factors_for_land_use[engine_type_id]
	var upgrade_factor_for_winter_supply = powerplants_upgrade_factors_for_winter_supply[engine_type_id]
	var upgrade_factor_for_summer_supply = powerplants_upgrade_factors_for_summer_supply[engine_type_id]
	var upgrade_cost = powerplants_upgrade_costs[engine_type_id]
	var can_upgrade = powerplants_can_upgrade[engine_type_id]
	
	var metrics = PowerplantMetrics.new(engine_type_id, capacity, cnv_capacity,
			emissions, land_use, production_cost, availability, building_costs,
			build_time_in_turns, life_span_in_turns, can_activate, active, can_delete,
			construction_started_on_turn, built_on_turn, current_upgrade,
			min_upgrade, max_upgrade, upgrade_factor_for_production_costs,
			upgrade_factor_for_emissions, upgrade_factor_for_land_use,
			upgrade_factor_for_winter_supply, upgrade_factor_for_summer_supply,
			upgrade_cost, can_upgrade)
			
	powerplants_metrics[engine_type_id] = metrics
	

# Update everything that buildings affects like supply, emissions, land_use, etc.
func update_buildings_impact():
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	
	var summer = 0
	var winter = 0
	var total_production_costs = 0
	var total_emissions = 0
	var total_land_use = 0
	
	for powerplant in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		
		if metrics.active:
			summer += metrics.capacity * metrics.availability.x
			winter += metrics.capacity * metrics.availability.y
			total_production_costs += metrics.production_costs
			total_emissions += metrics.emissions
						
			total_land_use += metrics.land_use
			
	Gameloop.supply_summer = summer
	Gameloop.supply_winter = winter
	MoneyManager.powerplants_production_costs = total_production_costs
	Gameloop.co2_emissions = total_emissions
	Gameloop.land_use = total_land_use
	
	
func get_production_costs_by_plant_type(type: EngineTypeIds):
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	var costs = 0
	
	for powerplant in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		
		if metrics.type == type and metrics.active:
			costs += metrics.production_costs
		
	return costs


func get_co2_emitted_by_plant_type(type: EngineTypeIds):
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	var co2_emitted = 0
	
	for powerplant in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		
		if metrics.type == type and metrics.active:
			co2_emitted += metrics.emissions
		
	return co2_emitted
	
	
func get_land_use_by_plant_type(type: EngineTypeIds):
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	var land_use = 0
	
	for powerplant in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		
		if metrics.type == type and metrics.active:
			land_use += metrics.land_use
		
	return land_use
	
	
func get_energy_provided_by_plant_type(type: EngineTypeIds):
	var powerplants: Array[Node] = get_tree().get_nodes_in_group("Powerplants")
	var summer_supply = 0
	var winter_supply = 0
	
	for powerplant in powerplants:
		var metrics: PowerplantMetrics = powerplant.metrics
		
		if metrics.type == type and metrics.active:
			summer_supply += metrics.capacity * metrics.availability.x
			winter_supply += metrics.capacity * metrics.availability.y
		
		
	return {
		"summer_supply": summer_supply,
		"winter_supply": winter_supply
	}
	

func backup_metrics():
	metrics_backup = []
	
	for metric in powerplants_metrics:
		metrics_backup.push_back(metric.copy())


func rollback_metrics():
	powerplants_metrics = []
	
	for metric in metrics_backup:
		powerplants_metrics.push_back(metric.copy())
		
	metrics_backup = []


func get_powerplant_image_path(type: EngineTypeIds, upgrade: int, active: bool) -> String:
	var images = []
	var path = ""
	
	if active:
		images = powerplants_textures_on[type]
	else:
		images = powerplants_textures_off[type]
		
		
	if images.size() > upgrade:
		path = images[upgrade]
	else:
		path = images[0]
	
	return path
