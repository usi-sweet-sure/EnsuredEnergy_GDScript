extends Node

signal borrowed_money_amount_updated(val: float)
signal players_own_money_amount_updated(val: float)
signal available_money_amount_updated(val: float)
signal powerplants_production_costs_updated(val: float)
signal carbon_sequestration_production_costs_updated(val: float)
signal energy_import_cost_updated(val: float)
signal building_costs_updated(val: float)
signal total_production_costs_updated(val: float)
signal import_count_updated(count: int, authorized: int)

var import_count_authorized = 2
var start_money: float = 1411.0
var money_per_turn: float = 200.0
var debt_percentage_on_borrowed_money: float = 20.0
var borrowed_money_amount: float:
	set(new_value):
		borrowed_money_amount = new_value
		borrowed_money_amount_updated.emit(borrowed_money_amount)
		available_money_amount_updated.emit(available_money_amount)
var players_own_money_amount: float:
	set(new_value):
		players_own_money_amount = new_value
		players_own_money_amount_updated.emit(players_own_money_amount)
		available_money_amount_updated.emit(available_money_amount)
# This is a compute of all the money sources, minus costs. Do not set it
var available_money_amount: float:
	get:
		return players_own_money_amount + borrowed_money_amount - building_costs - total_production_costs - energy_import_cost
# Do not set this directly
var total_production_costs: float:
	get:
		return powerplants_production_costs + carbon_sequestration_production_costs
var powerplants_production_costs: float:
	get:
		return powerplants_production_costs * production_costs_modifier
	set(new_value):
		powerplants_production_costs = new_value
		powerplants_production_costs_updated.emit(powerplants_production_costs)
		available_money_amount_updated.emit(available_money_amount)
		total_production_costs_updated.emit(total_production_costs)
var carbon_sequestration_production_costs: float:
	get:
		return carbon_sequestration_production_costs * production_costs_modifier
	set(new_value):
		carbon_sequestration_production_costs = new_value
		carbon_sequestration_production_costs_updated.emit(carbon_sequestration_production_costs)
		available_money_amount_updated.emit(available_money_amount)
		total_production_costs_updated.emit(total_production_costs)
var production_costs_modifier: float: # Shocks can affect this
	set(new_value):
		production_costs_modifier = new_value
		powerplants_production_costs_updated.emit(powerplants_production_costs)
		carbon_sequestration_production_costs_updated.emit(carbon_sequestration_production_costs)
		available_money_amount_updated.emit(available_money_amount)
var building_costs: float: # Costs of building and upgrading buildings
	set(new_value):
		building_costs = new_value
		building_costs_updated.emit(building_costs)
		available_money_amount_updated.emit(available_money_amount)
var energy_import_cost: float:
	get:
		return Gameloop.imported_energy_amount * 0.7
var import_count := 0:
	set(new_value):
		import_count = new_value
		import_count_updated.emit(import_count, import_count_authorized)


func _ready():
	players_own_money_amount = start_money
	Gameloop.player_can_start_playing_new_turn.connect(_on_new_turn)


func can_spend_the_money(money_to_spend: float):
	return money_to_spend <= available_money_amount


# Returns the money the player would have available on next turn
func get_money_for_next_turn() -> float:
	var income = players_own_money_amount + money_per_turn + borrowed_money_amount
	var outcome = borrowed_money_amount * (1.0 + (debt_percentage_on_borrowed_money / 100.0)) + energy_import_cost + building_costs + total_production_costs
	
	return income - outcome
	
	
func set_money_for_new_turn():
	# Production costs are not computed because they already are in "available_money",
	var income = players_own_money_amount + money_per_turn + borrowed_money_amount
	var outcome = borrowed_money_amount * (1.0 + (debt_percentage_on_borrowed_money / 100.0)) + building_costs + energy_import_cost
	players_own_money_amount = income - outcome
	borrowed_money_amount = 0
	building_costs = 0


func _on_new_turn():
	import_count = 0
