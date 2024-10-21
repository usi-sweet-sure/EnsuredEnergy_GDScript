extends Resource

class_name PowerplantMetrics

var type: PowerplantsManager.EngineTypeIds
var capacity: float
var cnv_capacity: float
var emissions: float
var land_use: float
var production_costs: float
var availability: Vector2
var building_costs: float
var build_time_in_turns: int
var life_span_in_turns: int
# If a plant shuts down because of life span or any other reason than the
# the player using the switch, the plant shouldn't be activated again
var can_activate: bool
var active: bool
var can_delete: bool
var construction_started_on_turn: int
var built_on_turn: int # When the powerplant was really built, not when the construction started
var current_upgrade: int
var min_upgrade: int
var max_upgrade: int
var upgrade_factor_for_production_costs: float
var upgrade_factor_for_emissions: float
var upgrade_factor_for_land_use: float
var upgrade_factor_for_winter_supply: float
var upgrade_factor_for_summer_supply: float
var upgrade_cost: float
var can_upgrade: bool


func _init(
		type_: PowerplantsManager.EngineTypeIds,
		capacity_: float,
		cnv_capacity_: float,
		emissions_: float,
		land_use_: float,
		production_costs_: float,
		availability_: Vector2,
		building_costs_: float,
		build_time_in_turns_: int,
		life_span_in_turns_: int,
		can_activate_:bool,
		active_: bool,
		can_delete_: bool,
		construction_started_on_turn_: int,
		built_on_turn_: int,
		current_upgrade_: int,
		min_upgrade_: int,
		max_upgrade_: int,
		upgrade_factor_for_production_costs_: float,
		upgrade_factor_for_emissions_: float,
		upgrade_factor_for_land_use_: float,
		upgrade_factor_for_winter_supply_: float,
		upgrade_factor_for_summer_supply_: float,
		upgrade_cost_: float,
		can_upgrade_: bool,
	):
		self.type = type_
		self.capacity = capacity_
		self.cnv_capacity = cnv_capacity_
		self.emissions = emissions_
		self.land_use = land_use_
		self.production_costs = production_costs_
		self.availability = availability_
		self.building_costs = building_costs_
		self.build_time_in_turns = build_time_in_turns_
		self.life_span_in_turns = life_span_in_turns_
		self.can_activate = can_activate_
		self.active = active_
		self.can_delete = can_delete_
		self.construction_started_on_turn = construction_started_on_turn_
		self.built_on_turn = built_on_turn_
		self.current_upgrade = current_upgrade_
		self.min_upgrade = min_upgrade_
		self.max_upgrade = max_upgrade_
		self.upgrade_factor_for_production_costs = upgrade_factor_for_production_costs_
		self.upgrade_factor_for_emissions = upgrade_factor_for_emissions_
		self.upgrade_factor_for_land_use = upgrade_factor_for_land_use_
		self.upgrade_factor_for_winter_supply = upgrade_factor_for_winter_supply_
		self.upgrade_factor_for_summer_supply = upgrade_factor_for_summer_supply_
		self.upgrade_cost = upgrade_cost_
		self.can_upgrade = can_upgrade_


func copy() -> PowerplantMetrics:
	var metrics = PowerplantMetrics.new(type, capacity, cnv_capacity,
			emissions, land_use, production_costs, availability, building_costs,
			build_time_in_turns, life_span_in_turns, can_activate, active, can_delete,
			construction_started_on_turn, built_on_turn, current_upgrade,
			min_upgrade, max_upgrade, upgrade_factor_for_production_costs,
			upgrade_factor_for_emissions, upgrade_factor_for_land_use,
			upgrade_factor_for_winter_supply, upgrade_factor_for_summer_supply,
			upgrade_cost, can_upgrade)
			
	return metrics
