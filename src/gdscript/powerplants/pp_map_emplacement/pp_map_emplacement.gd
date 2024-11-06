extends Node2D

class_name PpMapEmplacement

signal history_updated(history: MapEmplacementHistory)


@export var is_for_tutorial = false

# Editor will enumerate as 0, 1 and 2.
# MUST BE in same order as PowerplantManager.EngineTypeIds
@export_enum(
	"SOLAR",
	"WIND",
	"GAS",
	"WASTE",
	"BIOMASS",
	"BIOGAS",
	"NUCLEAR",
	"CARBON_SEQUESTRATION",
	"HYDRO",
	"RIVER",
	"NOTHING"
) var build_on_start: int = 10 # 10 = Nothing

@export_group("Can Build")
@export var solar := true
@export var wind := true
@export var gas := true
@export var waste := true
@export var biomass := true
@export var biogas := true
@export var nuclear := false
@export var carbon_sequestration := false
@export var hydro := false
@export var river := false

@export_group("Metrics Overrides")
@export var life_span_in_turns = 11:
	set(new_value):
		life_span_in_turns = new_value
		override_life_span = true
var override_life_span = false
@export var upgrade_factor_for_production_costs = -1:
	set(new_value):
		upgrade_factor_for_production_costs = new_value
		override_upgrade_factor_for_production_costs = true
var override_upgrade_factor_for_production_costs = false
@export var upgrade_factor_for_emissions = -1:
	set(new_value):
		upgrade_factor_for_emissions = new_value
		override_upgrade_factor_for_emissions = true
var override_upgrade_factor_for_emissions = false
@export var upgrade_factor_for_land_use = -1:
	set(new_value):
		upgrade_factor_for_land_use = new_value
		override_upgrade_factor_for_land_use = true
var override_upgrade_factor_for_land_use = false
@export var upgrade_factor_for_winter_supply = -1:
	set(new_value):
		upgrade_factor_for_winter_supply = new_value
		override_upgrade_factor_for_winter_supply = true
var override_upgrade_factor_for_winter_supply = false
@export var upgrade_factor_for_summer_supply = -1:
	set(new_value):
		upgrade_factor_for_summer_supply = new_value
		override_upgrade_factor_for_summer_supply = true
var override_upgrade_factor_for_summer_supply = false
@export var current_upgrade = -1:
	set(new_value):
		current_upgrade = new_value
		override_current_upgrade = true
var override_current_upgrade = false
@export var max_upgrade = -1:
	set(new_value):
		max_upgrade = new_value
		override_max_upgrade = true
var override_max_upgrade = false
@export var can_upgrade = true:
	set(new_value):
		can_upgrade = new_value
		override_can_upgrade = true
var override_can_upgrade = false

@export_group("Textures Overrides")
@export var build_button: Texture:
	set(new_value):
		build_button = new_value
		override_bb_texture = true
var override_bb_texture = false
## Will override the texture no matter which powerplant is built.
## This is intented for powerplants that are built on start
@export var powerplant_on: Texture:
	set(new_value):
		powerplant_on = new_value
		override_powerplant_on_texture = true
var override_powerplant_on_texture = false
## Will override the texture no matter which powerplant is built.
## This is intented for powerplants that are built on start
@export var powerplant_off: Texture:
	set(new_value):
		powerplant_off = new_value
		override_powerplant_off_texture = true
var override_powerplant_off_texture = false

@onready var bb_normal = $BbNormal
@onready var bb_in_construction = $BbInConstruction

var can_build: Array[PowerplantsManager.EngineTypeIds] = []
# Used to save the name of the pp node when it's built, to know it's name to delete it
# later
var powerplant_node_name: String = ""
var history: MapEmplacementHistory

func _ready():
	TutorialManager.tutorial_started.connect(_on_tutorial_started)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)
	PowerplantsManager.powerplant_build_requested.connect(_on_powerplant_build_requested)
	history = MapEmplacementHistory.new()
	history.history_updated.connect(_on_history_updated)
	
	# Will be disconnected after the first signal emition
	if build_on_start != 10: # 10 = Nothing
		PowerplantsManager.powerplants_metrics_updated.connect(_build_on_start)
	
	if solar:
		can_build.push_back(PowerplantsManager.EngineTypeIds.SOLAR)
	if wind:
		can_build.push_back(PowerplantsManager.EngineTypeIds.WIND)
	if gas:
		can_build.push_back(PowerplantsManager.EngineTypeIds.GAS)
	if waste:
		can_build.push_back(PowerplantsManager.EngineTypeIds.WASTE)
	if biomass:
		can_build.push_back(PowerplantsManager.EngineTypeIds.BIOMASS)
	if biogas:
		can_build.push_back(PowerplantsManager.EngineTypeIds.BIOGAS)
	if nuclear:
		can_build.push_back(PowerplantsManager.EngineTypeIds.NUCLEAR)
	if carbon_sequestration:
		can_build.push_back(PowerplantsManager.EngineTypeIds.CARBON_SEQUESTRATION)
	if hydro:
		can_build.push_back(PowerplantsManager.EngineTypeIds.HYDRO)
	if river:
		can_build.push_back(PowerplantsManager.EngineTypeIds.RIVER)
	
	if override_bb_texture:
		bb_normal.texture_normal = build_button
		
func _on_bb_normal_toggled(toggled_on: bool):
	# The build menu listens to this and emits back a build request with necessary,
	# data, managed in "_on_powerplant_build_requested" below
	PowerplantsManager.build_button_normal_toggled.emit(toggled_on, self, can_build)
	
	
func _on_bb_in_construction_toggled(toggled_on):
	PowerplantsManager.build_button_in_construction_toggled.emit(toggled_on, self)
	
	
func _on_powerplant_build_requested(map_emplacement: Node, metrics: PowerplantMetrics):
	if map_emplacement == self:
		bb_normal.hide()
		bb_in_construction.hide()
		
		var new_metrics = metrics.copy()
		override_metrics(new_metrics)
		
		if new_metrics.build_time_in_turns > 0:
			MoneyManager.building_costs += new_metrics.building_costs
			Gameloop.available_money_message_requested.emit("-" + str(new_metrics.building_costs + new_metrics.production_costs).pad_decimals(1) + "M CHF", false)
			new_metrics.construction_started_on_turn = Gameloop.current_turn
			bb_in_construction.set_metrics(new_metrics)
			bb_in_construction.show()
			history.pp_construction_started(new_metrics)
		else:
			MoneyManager.building_costs += new_metrics.building_costs
			Gameloop.available_money_message_requested.emit("-" + str(new_metrics.building_costs + new_metrics.production_costs).pad_decimals(1) + "M CHF", false)
			# == 0 means it was not set yet.
			# It's already set when the pp takes multiple turns to build
			if new_metrics.construction_started_on_turn == 0:
				new_metrics.construction_started_on_turn = Gameloop.current_turn
			
			new_metrics.built_on_turn = Gameloop.current_turn
			var pp_scene = PowerplantsManager.powerplant_scene.instantiate()
			add_child(pp_scene)
			powerplant_node_name = pp_scene.name
			pp_scene.set_metrics(new_metrics)
			history.pp_built(new_metrics)
			
			pp_scene.powerplant_activated.connect(_on_pp_activated)
			pp_scene.powerplant_deactivated.connect(_on_pp_deactivated)
			pp_scene.powerplant_upgraded.connect(_on_pp_upgraded)
			pp_scene.powerplant_downgraded.connect(_on_pp_downgraded)
			pp_scene.powerplant_delete_requested.connect(_on_powerplant_delete_requested)
				
			pp_scene.activate(true)
			
			if new_metrics.current_upgrade > 0:
				var target_upgrade = new_metrics.current_upgrade
				new_metrics.current_upgrade = 0
				new_metrics.active = true
				pp_scene.set_metrics(new_metrics)
				
				var count = 1
				
				while count <= target_upgrade:
					pp_scene._on_button_plus_pressed()
					count += 1
			
			if override_powerplant_on_texture:
				pp_scene.set_texture_on(powerplant_on, "")
			if override_powerplant_off_texture:
				pp_scene.set_texture_off(powerplant_off)


# Connected to "powerplant_delete_requested" emitted by "pp_scene.tscn"
func _on_powerplant_delete_requested(metrics: PowerplantMetrics):
	var refunded_money = metrics.building_costs
	
	# Gives back the money that was used to upgrade
	if metrics.current_upgrade > 0:
		refunded_money += metrics.current_upgrade * metrics.upgrade_cost
	
	MoneyManager.building_costs -= refunded_money
	
	if not metrics.active:
		# production costs where already deducted
		Gameloop.available_money_message_requested.emit("+" + str(refunded_money).pad_decimals(2) + "M CHF", true)
	else:
		Gameloop.available_money_message_requested.emit("+" + str(refunded_money + metrics.production_costs).pad_decimals(2) + "M CHF", true)
	history.pp_deleted(metrics)
	
	var node = get_node(powerplant_node_name)
	remove_child(node)
	node.queue_free()
	bb_normal.show()
	PowerplantsManager.update_buildings_impact()
	TutorialManager.next_step_requested.emit()


func _on_powerplant_cancel_construction_requested(metrics: PowerplantMetrics):
	MoneyManager.building_costs -= metrics.building_costs
	Gameloop.available_money_message_requested.emit("+" + str(metrics.building_costs + metrics.production_costs).pad_decimals(1) + "M CHF", true)
	history.pp_construction_canceled(metrics)
	
	bb_in_construction.hide()
	bb_normal.show()
	TutorialManager.next_step_requested.emit()
	

func _build_on_start(metrics: Array[PowerplantMetrics]):
	PowerplantsManager.powerplants_metrics_updated.disconnect(_build_on_start)
	var new_metrics = metrics[build_on_start].copy()
	new_metrics.build_time_in_turns = 0
	new_metrics.can_delete = false
	new_metrics.building_costs = 0
	_on_powerplant_build_requested(self, new_metrics)
	# We don't want the pp built automatically at the beginning of the game
	# to count as a user action
	history.remove_history_for_turn(Gameloop.current_turn)
	

# Applies the changes made in the editor
func override_metrics(metrics: PowerplantMetrics):
	if override_life_span:
		metrics.life_span_in_turns = life_span_in_turns
		
	if override_upgrade_factor_for_production_costs:
		metrics.upgrade_factor_for_production_costs = upgrade_factor_for_production_costs
		
	if override_upgrade_factor_for_emissions:
		metrics.upgrade_factor_for_emissions = upgrade_factor_for_emissions
		
	if override_upgrade_factor_for_land_use:
		metrics.upgrade_factor_for_land_use = upgrade_factor_for_land_use
		
	if override_upgrade_factor_for_winter_supply:
		metrics.upgrade_factor_for_winter_supply = upgrade_factor_for_winter_supply
		
	if override_upgrade_factor_for_summer_supply:
		metrics.upgrade_factor_for_summer_supply = upgrade_factor_for_summer_supply

	if override_max_upgrade:
		metrics.max_upgrade = max_upgrade
	
	if override_current_upgrade:
		metrics.current_upgrade = current_upgrade
		
	if override_can_upgrade:
		metrics.can_upgrade = can_upgrade
		
		
func _on_powerplant_construction_ended(metrics: PowerplantMetrics):
	metrics.build_time_in_turns = 0
	metrics.building_costs = 0 # already paid when the construction started
	PowerplantsManager.powerplant_build_requested.emit(self, metrics)


func _on_pp_activated(metrics: PowerplantMetrics):
	history.pp_activated(metrics)
	
	
func _on_pp_deactivated(metrics: PowerplantMetrics):
	history.pp_deactivated(metrics)
	
	
func _on_pp_upgraded(metrics: PowerplantMetrics):
	history.pp_upgraded(metrics)
	
	
func _on_pp_downgraded(metrics: PowerplantMetrics):
	history.pp_downgraded(metrics)
	

func _on_history_updated(history_: MapEmplacementHistory):
	history_updated.emit(history_)


func _on_tutorial_started():
	visible = is_for_tutorial
	
	
func _on_tutorial_ended():
	visible = not is_for_tutorial
