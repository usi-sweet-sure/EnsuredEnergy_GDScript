extends CanvasLayer

signal game_stats_updated(game_stats: Dictionary)

var game_stats = {
	"reached_net_zero": false,
	"emissions_diff_percentage": 0,
	"emissions_per_plant_type": {},
	"summer_energy_per_plant_type": {},
	"winter_energy_per_plant_type": {},
	"production_costs_diff_percentage": 0,
	"production_costs_per_plant_type": {},
	"land_use_diff_percentage": 0,
	"land_use_per_plant_type": {},
	"nuclear_energy_percentage": 0,
	"implemented_policies_count": 0,
	"imported_energy_percentage": 0,
}


func _ready():
	Gameloop.game_ended.connect(_on_game_ended)


func _on_game_ended():
	show()
	compute_game_stats()
	
	
func compute_game_stats():
	# CO2
	var emissions_in_2022 = GraphsData.get_data_for_year("co2_emissions", Gameloop.start_year).value
	var emissions_now = GraphsData.get_data_for_year("co2_emissions", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	emissions_now -= Gameloop.sequestrated_co2
	game_stats.reached_net_zero = emissions_now == 0
	game_stats.emissions_diff_percentage = (emissions_now * 100.0 / emissions_in_2022) -100.0

	# Nuclear
	var nuclear_supply = PowerplantsManager.get_energy_provided_by_plant_type(PowerplantsManager.EngineTypeIds.NUCLEAR)
	var total_nuclear_energy = nuclear_supply.winter_supply + nuclear_supply.summer_supply
	var total_energy = Gameloop.supply_summer + Gameloop.supply_winter
	var nuclear_energy_percentage = total_nuclear_energy * 100.0 / total_energy
	game_stats.nuclear_energy_percentage = nuclear_energy_percentage
	
	# Production costs
	var production_costs_in_2022 = GraphsData.get_data_for_year("production_costs", Gameloop.start_year).value
	var production_costs_now = GraphsData.get_data_for_year("production_costs", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	var production_costs_diff_percentage = (production_costs_now * 100.0 / production_costs_in_2022) -100.0
	game_stats.production_costs_diff_percentage = production_costs_diff_percentage
	
	# Land use
	var land_use_in_2022 = GraphsData.get_data_for_year("land_use", Gameloop.start_year).value
	var land_use_now = GraphsData.get_data_for_year("land_use", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	var land_use_diff_percentage = (land_use_now * 100.0 / land_use_in_2022) -100.0
	game_stats.land_use_diff_percentage = land_use_diff_percentage
	
	# Policies
	game_stats.implemented_policies_count = PolicyManager.get_implemented_policies_count()
	
	# Imported energy
	var imported_energy_amount = Gameloop.imported_energy_amount
	var total_winter_energy = Gameloop.supply_winter
	game_stats.imported_energy_percentage =  imported_energy_amount * 100.0 / total_winter_energy
	
	# Per type stats
	for type in PowerplantsManager.EngineTypeIds.values():
		game_stats.emissions_per_plant_type[type] = PowerplantsManager.get_co2_emitted_by_plant_type(type)
		var energy = PowerplantsManager.get_energy_provided_by_plant_type(type)
		game_stats.summer_energy_per_plant_type[type] = energy.summer_supply
		game_stats.winter_energy_per_plant_type[type] = energy.winter_supply
		game_stats.land_use_per_plant_type[type] = PowerplantsManager.get_land_use_by_plant_type(type)
		game_stats.production_costs_per_plant_type[type] = PowerplantsManager.get_production_costs_by_plant_type(type)


	game_stats_updated.emit(game_stats)
