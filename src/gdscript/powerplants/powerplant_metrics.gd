# Used as a "custom type" to provide autocompletion
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
# Each entry is the history of what happened to the powerplant during the turn
# corresponding to the index.
# A turn history is an Array of 1, -1, true or false, or an emptry array if nothing
# happened.
# For example, history[1] = [1, 1, -1, false, true, false, true]
# means the pp was upgraded twice, downgraded once, then turned off, turned on,
# turned off and finally turned back on. So the history for turn 2, would mean
# that the pp was upgraded once.
# If it was history[1] = [1, 1, -1, false, true, false],
# the history would mean that the pp was upgraded once, and then turned off.
# When informing the model at the end of turn 2, the information we would give it
# would then be that the pp was simply turned off
var history: Array

func _init(
		type: PowerplantsManager.EngineTypeIds,
		capacity: float,
		cnv_capacity: float,
		emissions: float,
		land_use: float,
		production_costs: float,
		availability: Vector2,
		building_costs: float,
		build_time_in_turns: int,
		life_span_in_turns: int,
		can_activate:bool,
		active: bool,
		can_delete: bool,
		construction_started_on_turn: int,
		built_on_turn: int,
		current_upgrade: int,
		min_upgrade: int,
		max_upgrade: int,
		upgrade_factor_for_production_costs: float,
		upgrade_factor_for_emissions: float,
		upgrade_factor_for_land_use: float,
		upgrade_factor_for_winter_supply: float,
		upgrade_factor_for_summer_supply: float,
		upgrade_cost: float,
		can_upgrade: bool,
	):
		self.type = type
		self.capacity = capacity
		self.cnv_capacity = capacity
		self.emissions = emissions
		self.land_use = land_use
		self.production_costs = production_costs
		self.availability = availability
		self.building_costs = building_costs
		self.build_time_in_turns = build_time_in_turns
		self.life_span_in_turns = life_span_in_turns
		self.can_activate = can_activate
		self.active = active
		self.can_delete = can_delete
		self.construction_started_on_turn = construction_started_on_turn
		self.built_on_turn = built_on_turn
		self.current_upgrade = current_upgrade
		self.min_upgrade = min_upgrade
		self.max_upgrade = max_upgrade
		self.upgrade_factor_for_production_costs = upgrade_factor_for_production_costs
		self.upgrade_factor_for_emissions = upgrade_factor_for_emissions
		self.upgrade_factor_for_land_use = upgrade_factor_for_land_use
		self.upgrade_factor_for_winter_supply = upgrade_factor_for_winter_supply
		self.upgrade_factor_for_summer_supply = upgrade_factor_for_summer_supply
		self.upgrade_cost = upgrade_cost
		self.can_upgrade = can_upgrade


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
