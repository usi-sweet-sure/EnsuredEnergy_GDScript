extends Node2D

var start_year: int = 2022
var total_number_of_turns: int = 10
var start_money: int = 250
var money_per_turn: int = 250
var green_energy_import_factor: float = 1.5
var debt_percentage_on_borrowed_money: int = 20

var demand_summer_list = []
var demand_winter_list = []
var year_list = []
var all_power_plants

var ups_list = {
	"186": 0,
	"151": 0,
	"162": 0,
	"163": 0,
	"189": 0,
	"192": 0,
	"170": 0,
	"171": 0,
	"246": 0
	}

signal energy_supply_updated_winter
signal energy_supply_updated_summer
signal energy_demand_updated_winter
signal energy_demand_updated_summer
signal green_energy_import_on_updated
signal imported_energy_amount_updated
signal borrowed_money_amount_updated
signal players_own_money_amount_updated
signal available_money_amount_updated
signal land_use_percentage_updated
signal biodiversity_percentage_updated
signal co2_emissions_updated
signal imports_emissions_updated
signal most_recent_shock_updated
signal current_turn_updated

signal next_turn
signal end

var demand_summer: float = 1000:
	set(new_value):
		demand_summer = new_value;
		print("Summer demand updated : " + str(demand_summer))
		energy_demand_updated_summer.emit(new_value)
var demand_winter: float = 1200:
	set(new_value):
		demand_winter = new_value
		#print("Winter demand updated : " + str(demand_winter))
		energy_demand_updated_winter.emit(new_value)
var supply_summer: int = 0:
	set(new_value):
		supply_summer = new_value
		#print("Summer supply updated : " + str(supply_summer))
		energy_supply_updated_summer.emit(supply_summer)
var supply_winter: int = 0:
	set(new_value):
		supply_winter = new_value
		#print("Summer supply updated : " + str(supply_winter))
		#print("Winter supply updated : " + str(supply_winter))
		energy_supply_updated_winter.emit(supply_winter)
var energy_import_cost: float = 0:
	get:
		if not green_energy_import_on:
			return imported_energy_amount 
		else:
			return imported_energy_amount * green_energy_import_factor
var green_energy_import_on := false:
	set(new_value):
		green_energy_import_on = new_value
		green_energy_import_on_updated.emit(green_energy_import_on)
var imported_energy_amount: float = 0:
	set(new_value):
		imported_energy_amount = new_value
		imported_energy_amount_updated.emit(imported_energy_amount)
var borrowed_money_amount: int = 0:
	set(new_value):
		borrowed_money_amount = new_value
		borrowed_money_amount_updated.emit(borrowed_money_amount)
		available_money_amount_updated.emit(available_money_amount)
var players_own_money_amount: int = 0:
	set(new_value):
		players_own_money_amount = new_value
		players_own_money_amount_updated.emit(players_own_money_amount)
		available_money_amount_updated.emit(available_money_amount)
# This is a sum of all the money sources, so don't set this variable, but the
# parts used to compute it
var available_money_amount: int = 0:
	get:
		return players_own_money_amount + borrowed_money_amount # E. add other money resources as we add them
var land_use_percentage: int = 37:
	set(new_value):
		land_use_percentage = clamp(new_value, 0, 100)
		land_use_percentage_updated.emit(land_use_percentage)
var biodiversity_percentage: int = 67:
	set(new_value):
		biodiversity_percentage = clamp(new_value, 0, 100)
		biodiversity_percentage_updated.emit(biodiversity_percentage)
var co2_emissions: int = 17:
	set(new_value):
		co2_emissions = clamp(new_value, 0, 100)
		co2_emissions_updated.emit(co2_emissions)
var imports_emissions: int = 0:
	set(new_value):
		imports_emissions = clamp(new_value, 0, 100)
		imports_emissions_updated.emit(imports_emissions)
var most_recent_shock: Shock = null:
	set(new_value):
		most_recent_shock = new_value
		most_recent_shock_updated.emit(most_recent_shock)
var current_turn: int = 1:# Player action always take place in the following year
	set(new_value):
		current_turn = new_value
		current_turn_updated.emit(current_turn)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	players_own_money_amount = start_money
	all_power_plants = get_tree().get_nodes_in_group("PP")
	for i in total_number_of_turns + 1:
		year_list.append(start_year + (i * 3))
		
	next_turn.connect(_send_prm_ups)
	#Context1.http1.request_completed.connect(_on_request_completed)
	
	# TODO get all the demands for each year for the graph (nice to have)
#func _on_request_completed(_result, _response_code, _headers, _body):
	#for year in year_list:
		#Context1.yr = str(year)
		#Context1.get_ctx()
		#for i in Context1.ctx1:
			#if i["prm_id"] == "454":
				#Gameloop.demand_summer_list.append(float(i["tj"]) / 100)
			#if i["prm_id"] == "455":
				#Gameloop.demand_winter_list.append(float(i["tj"]) / 100)
		#await Context1.http1.request_completed
			

func _update_supply():
	all_power_plants = get_tree().get_nodes_in_group("PP")
	var summer = 0
	var winter = 0
	var total_production_costs = 0
	for power_plant in all_power_plants:
		if power_plant.is_alive:
			summer += power_plant.capacity * power_plant.availability.x
			winter += power_plant.capacity * power_plant.availability.y
			total_production_costs += power_plant.production_cost
	supply_summer = summer
	supply_winter = winter
	#print(total_production_costs)
	
	
func _check_supply():
	return supply_summer >= demand_summer and supply_winter + imported_energy_amount >= demand_winter
	

func _send_prm_ups():
	for i in ups_list:
		Context1.prm_id = i
		Context1.yr = Gameloop.year_list[Gameloop.current_turn-1]
		Context1.tj = ups_list[i]
		Context1.prm_ups()
		await Context1.http1.request_completed
		 

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
			
func can_go_to_next_turn():
	return _check_supply()
