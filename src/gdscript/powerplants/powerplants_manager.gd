extends Node

# All empty map emplacements listen to this, but will only build if they are
# the node passed in the parameters
signal powerplant_build_requested(map_emplacement: PpMapEmplacement, metrics: PowerplantMetrics)
# The 3 signals below are used by the 3 concerned node types so they can update their focus state
signal build_button_normal_toggled(toggled_on: bool, target_map_emplacement: PpMapEmplacement, can_build: Array[EngineTypeIds])
signal build_button_in_construction_toggled(toggled_on: bool, target_map_emplacement: PpMapEmplacement)
signal pp_scene_toggled(toggled_on: bool, pp_scene: PpScene)
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

# Used by all the types. Texture is set at runtime when the scene is instantiated
var powerplant_scene = preload("res://scenes/powerplants/pp_map_emplacement/pp_scene.tscn")

# MUST BE in the same order as EngineTypeIds
var powerplants_textures_on: Array[Image] = [
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_solar.png"), # Solar
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_wind.png"), # Wind
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_gas.png"), # Gas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_waste.png"), # Waste
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_biomass.png"), # Biomass
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_biogas.png"), # Biogas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_nuclear.png"), # Nuclear
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_carbon_sequestration.png"), # Carbon sequestration
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_hydro.png"), # Hydro
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_on_river.png"), # River 
]

# MUST BE in the same order as EngineTypeIds
var powerplants_textures_off: Array[Image] = [
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_solar.png"), # Solar
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_wind.png"), # Wind
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_gas.png"), # Gas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_waste.png"), # Waste
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_biomass.png"), # Biomass
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_biogas.png"), # Biogas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_nuclear.png"), # Nuclear
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_carbon_sequestration.png"), # Carbon sequestration
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_hydro.png"), # Hydro
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_off_river.png"), # River 
]

# MUST BE in the same order as EngineTypeIds
var powerplants_textures_neon: Array[Image] = [
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_solar.png"), # Solar
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_wind.png"), # Wind
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_gas.png"), # Gas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_waste.png"), # Waste
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_biomass.png"), # Biomass
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_biogas.png"), # Biogas
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_nuclear.png"), # Nuclear
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_carbon_sequestration.png"), # Carbon sequestration
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_hydro.png"), # Hydro
	Image.load_from_file("res://assets/used_assets/textures/powerplants/pp_sprite_neon_river.png"), # River 
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

var powerplants_max_upgrades: Array[int] = [
	3, # Solar
	3, # Wind
	3, # Gas
	3, # Waste
	3, # Biomass
	3, # Biogas
	3, # Nuclear
	3, # Carbon sequestration
	3, # Hydro
	3, # River
]

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

var powerplants_upgrade_factors: Array[float] = [
	0.025, # Solar
	0.025, # Wind
	0.025, # Gas
	0.025, # Waste
	0.025, # Biomass
	0.025, # Biogas
	0.025, # Nuclear
	0.025, # Carbon sequestration
	0.025, # Hydro
	0.025, # River
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
	Context.http.request_completed.connect(_on_request_finished)


func _on_request_finished(_result, _response_code, _headers, _body):
	if Context.ctx != null:
		powerplants_metrics = []
		
		for type in EngineTypeIds.values():
			# Makes room for the upcoming metrics, since it will be stored by
			# indexing the array instead of pushing back
			powerplants_metrics.push_back(null) 
			_store_powerplant_metrics(type)
			
		powerplants_metrics_updated.emit(powerplants_metrics)


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
					building_costs = production_cost * 2.0
				availability_key:
					availability.x = float(i["tj"]) / capacity
					availability.y = 1 - availability.x
	
	if engine_type_id == EngineTypeIds.NUCLEAR:
		capacity = capacity / 100.0 / 3.0 # there's 3 nuclear plants
		emissions /= 3.0
		land_use /= 3.0
		production_cost = production_cost / 10.0 / 3.0
	elif engine_type_id == EngineTypeIds.HYDRO || engine_type_id == EngineTypeIds.RIVER:
		capacity = capacity / 100.0 / 2.0
		emissions /= 4.0 # needs to divide by the number of water plants
		land_use /= 4.0
		production_cost = production_cost / 10.0 / 4.0
	else:
		capacity /= 100.0
	
	var can_activate = true
	var active = false
	var can_delete = true
	var built_on_turn = 0
	var current_upgrade = 0
	var min_upgrade = powerplants_min_upgrades[engine_type_id]
	var max_upgrade = powerplants_max_upgrades[engine_type_id]
	var upgrade_factor = powerplants_upgrade_factors[engine_type_id]
	
	var metrics = PowerplantMetrics.new(engine_type_id, capacity, cnv_capacity,
			emissions, land_use, production_cost, availability, building_costs,
			build_time_in_turns, life_span_in_turns, can_activate, active, can_delete,
			built_on_turn, current_upgrade, min_upgrade, max_upgrade, upgrade_factor)
			
	powerplants_metrics[engine_type_id] = metrics
