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
var life_time_in_turns: int
var active: bool


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
		life_time_in_turns: int,
		active: bool
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
		self.life_time_in_turns = life_time_in_turns
		self.active = active


func copy() -> PowerplantMetrics:
	var metrics = PowerplantMetrics.new(type, capacity, cnv_capacity,
			emissions, land_use, production_costs, availability, building_costs,
			build_time_in_turns, life_time_in_turns, active)
			
	return metrics
