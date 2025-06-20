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
signal unfocus_all


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
# The values below are inspired from the remote model used before offline mode.
# MUST BE in the same order as EngineTypeIds.
var powerplants_metrics: Array[PowerplantMetrics] = [
	PowerplantMetrics.new(
		0, # SOLAR
		20.6941191729591, # capacity
		2069.41191729591, # cnv_capacity
		0.04656176884503, # emissions
		0.17245099126101, # land_use
		5.74836647976175, # production_costs
		Vector2(0.754133, 0.245867), # availability
		22.993465919047, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		6, # max_upgrade
		0.2, # upgrade_factor_for_production_costs
		0.2, # upgrade_factor_for_emissions
		0.2, # upgrade_factor_for_land_use
		0.2, # upgrade_factor_for_winter_supply
		0.2, # upgrade_factor_for_summer_supply
		10.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		1, # WIND
		6.40379007643745, # capacity
		640.379007643745, # cnv_capacity
		0.00302401183943, # emissions
		0.37355440780593, # land_use
		2.3124796119901, # production_costs
		Vector2(0.379199, 0.620801), # availability
		2.3124796119901, # building_costs
		2, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		6, # max_upgrade
		0.5, # upgrade_factor_for_production_costs
		0.5, # upgrade_factor_for_emissions
		0.5, # upgrade_factor_for_land_use
		0.5, # upgrade_factor_for_winter_supply
		0.5, # upgrade_factor_for_summer_supply
		5.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		2, # GAS
		12.7554504023673, # capacity
		7211.04761904762, # cnv_capacity
		1.2018412569693, # emissions
		0.68104340693182, # land_use
		32.0490986188253, # production_costs
		Vector2(0.5, 0.5), # availability
		32.0490986188253, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		3, # max_upgrade
		0.5, # upgrade_factor_for_production_costs
		0.5, # upgrade_factor_for_emissions
		0.5, # upgrade_factor_for_land_use
		0.5, # upgrade_factor_for_winter_supply
		0.5, # upgrade_factor_for_summer_supply
		25.0, # upgrade_cost
		false, # can_upgrade
	),
	PowerplantMetrics.new(
		3, # WASTE
		22.2078188025172, # capacity
		12554.7619047619, # cnv_capacity
		0.02441203673752, # emissions
		0.1743716950603, # land_use
		31.3869052296061, # production_costs
		Vector2(0.5, 0.5), # availability
		125.547620918424, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		3, # max_upgrade
		0.25, # upgrade_factor_for_production_costs
		0.25, # upgrade_factor_for_emissions
		0.25, # upgrade_factor_for_land_use
		0.25, # upgrade_factor_for_winter_supply
		0.25, # upgrade_factor_for_summer_supply
		25.0, # upgrade_cost
		false, # can_upgrade
	),
	PowerplantMetrics.new(
		4, # BIOMASS
		13.4767717212224, # capacity
		5564.15621207101, # cnv_capacity
		0.0710975503649, # emissions
		19.4745473433634, # land_use
		44.5132470433716, # production_costs
		Vector2(0.5, 0.5), # availability
		37.094372536143, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		9, # max_upgrade
		0.25, # upgrade_factor_for_production_costs
		0.25, # upgrade_factor_for_emissions
		0.25, # upgrade_factor_for_land_use
		0.25, # upgrade_factor_for_winter_supply
		0.25, # upgrade_factor_for_summer_supply
		20.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		5, # BIOGAS
		12.2562652207836, # capacity
		4261.02702927362, # cnv_capacity
		0.41071566040541, # emissions
		0.18937898118428, # land_use
		24.8559895225636, # production_costs
		Vector2(0.5, 0.5), # availability
		24.8559895225636, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		9, # max_upgrade
		0.25, # upgrade_factor_for_production_costs
		0.25, # upgrade_factor_for_emissions
		0.25, # upgrade_factor_for_land_use
		0.25, # upgrade_factor_for_winter_supply
		0.25, # upgrade_factor_for_summer_supply
		15.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		6, # NUCLEAR
		267.618804300282, # capacity
		81094.746031746, # cnv_capacity
		0.31536845292076, # emissions
		2.92842149079216, # land_use
		202.73686810038, # production_costs
		Vector2(0.470475, 0.529525), # availability
		608.210604301139, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		0, # max_upgrade
		0.1, # upgrade_factor_for_production_costs
		0.1, # upgrade_factor_for_emissions
		0.1, # upgrade_factor_for_land_use
		0.1, # upgrade_factor_for_winter_supply
		0.1, # upgrade_factor_for_summer_supply
		25.0, # upgrade_cost
		false, # can_upgrade
	),
	PowerplantMetrics.new(
		7, # CARBON_SEQUESTRATION
		0.0, # capacity
		0.0, # cnv_capacity
		0.0, # emissions
		0.0, # land_use
		0.0, # production_costs
		Vector2(0.0, 0.0), # availability
		0.0, # building_costs
		0, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		3, # max_upgrade
		0.5, # upgrade_factor_for_production_costs
		0.5, # upgrade_factor_for_emissions
		0.5, # upgrade_factor_for_land_use
		0.5, # upgrade_factor_for_winter_supply
		0.5, # upgrade_factor_for_summer_supply
		25.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		8, # HYDRO
		345.54576390381, # capacity
		41497.7189174107, # cnv_capacity
		0.06916286468773, # emissions
		23.6306453421927, # land_use
		46.1085738266155, # production_costs
		Vector2(0.527875, 0.472125), # availability
		184.434295306462, # building_costs
		6, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		9, # max_upgrade
		0.02, # upgrade_factor_for_production_costs
		0.02, # upgrade_factor_for_emissions
		0.02, # upgrade_factor_for_land_use
		0.02, # upgrade_factor_for_winter_supply
		0.02, # upgrade_factor_for_summer_supply
		30.0, # upgrade_cost
		true, # can_upgrade
	),
	PowerplantMetrics.new(
		9, # RIVER
		315.555858398437, # capacity
		31555.5858398437, # cnv_capacity
		0.01753088157578, # emissions
		0.6574080312891, # land_use
		35.061759954427, # production_costs
		Vector2(0.587837, 0.412163), # availability
		140.247039817708, # building_costs
		3, # build_time_in_turns
		11, # life_span_in_turns
		true, # can_activate
		false, # active
		true, # can_delete
		0, # construction_started_on_turn
		0, # built_on_turn
		0, # current_upgrade
		0, # min_upgrade
		9, # max_upgrade
		0.02, # upgrade_factor_for_production_costs
		0.02, # upgrade_factor_for_emissions
		0.02, # upgrade_factor_for_land_use
		0.02, # upgrade_factor_for_winter_supply
		0.02, # upgrade_factor_for_summer_supply
		25.0, # upgrade_cost
		true, # can_upgrade
	)
]

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
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/biogas/pp_effects_biogas.tscn", # Biogas
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/nuclear/pp_effects_nuclear.tscn", # Nuclear
	"", # Carbon sequestration
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/hydro/pp_effects_hydro.tscn", # Hydro
	"res://scenes/powerplants/pp_map_emplacement/pp_effects/river/pp_effects_river.tscn", # River 
]

# Ambience sound playing when the powerplant is in focus
# MUST BE in the same order as EngineTypeIds
var powerplants_ambiences: Array[String] = [
	"res://assets/sounds/ambiences/wind.wav", # Solar
	"res://assets/sounds/ambiences/wind.wav", # Wind
	"res://assets/sounds/ambiences/Big_Smoke_Amb.wav", # Gas
	"res://assets/sounds/ambiences/Big_Smoke_Amb.wav", # Waste
	"res://assets/sounds/ambiences/Small_Smoke_Amb.wav", # Biomass
	"res://assets/sounds/ambiences/Small_Smoke_Amb.wav", # Biogas
	"res://assets/sounds/ambiences/Nuclear_Amb.wav", # Nuclear
	"res://assets/sounds/ambiences/wind.wav", # Carbon sequestration
	"res://assets/sounds/ambiences/Hydro_Water.wav", # Hydro
	"res://assets/sounds/ambiences/River_Water.wav", # River 
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
	 "res://assets/textures/powerplants/pp_sprite_on_wind_6.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_7.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_8.png",
	 "res://assets/textures/powerplants/pp_sprite_on_wind_9.png",],
	
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
	 "res://assets/textures/powerplants/pp_sprite_off_wind_6.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_7.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_8.png",
	 "res://assets/textures/powerplants/pp_sprite_off_wind_9.png",], 
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

func _ready():
	Gameloop.game_started.connect(_on_game_started)


func _on_game_started():
	Gameloop.demand_summer = 1000.0
	Gameloop.demand_winter = 1200.0
	powerplants_metrics_updated.emit(powerplants_metrics)
	Gameloop.player_can_start_playing_first_turn.emit()
		

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
