extends CanvasLayer

signal metrics_leaderboard_updated
signal metrics_rank_updated
signal game_stats_updated(game_stats: Dictionary)

@export var tick_icon: Texture2D
@export var pen_icon: Texture2D

var game_stats = {
	"reached_net_zero": false,
	"production_costs_diff_percentage": 0,
	"land_use_diff_percentage": 0,
	"nuclear_energy_percentage": 0,
	"implemented_policies_count": 0,
	"imported_energy_percentage": 0,
}

func _ready():
	Gameloop.game_ended.connect(_on_game_ended)
	Gameloop.show_ending_screen_requested.connect(_on_show_ending_screen)
	%player_name.placeholder_text = tr("PLAYER_NAME_PLACEHOLDER")
	Context.player_name_changed.connect(_on_player_name_changed)


func _on_game_ended():
	show()
	
	Context.get_rank(Context.res_id)
	await Context.rank_updated
	
	compute_game_stats()
		
	metrics_rank_updated.emit(Context.rank_json)
 
	Context.get_leaderboard_from_model("5")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("7")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("9")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("11")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("13")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("15")
	await Context.leaderboard_updated
	Context.get_leaderboard_from_model("17")
	await Context.leaderboard_updated
	
	metrics_leaderboard_updated.emit(Context.leaderboard_json)
	$MainFrame/Leaderboard.disabled = false
	$MainFrame/Summary.disabled = false
	
	
func compute_game_stats():
	var emissions_in_2022 = GraphsData.get_data_for_year("co2_emissions", Gameloop.start_year).value
	var emissions_now = GraphsData.get_data_for_year("co2_emissions", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	game_stats.reached_net_zero = emissions_now == 0
	
	var nuclear_supply = PowerplantsManager.get_energy_provided_by_plant_type(PowerplantsManager.EngineTypeIds.NUCLEAR)
	var total_nuclear_energy = nuclear_supply.winter_supply + nuclear_supply.summer_supply
	var total_energy = Gameloop.supply_summer + Gameloop.supply_winter
	var nuclear_energy_percentage = total_nuclear_energy * 100.0 / total_energy
	game_stats.nuclear_energy_percentage = nuclear_energy_percentage
			
	var production_costs_in_2022 = GraphsData.get_data_for_year("production_costs", Gameloop.start_year).value
	var production_costs_now = GraphsData.get_data_for_year("production_costs", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	var production_costs_diff_percentage = (production_costs_now * 100.0 / production_costs_in_2022) -100.0
	game_stats.production_costs_diff_percentage = production_costs_diff_percentage
	
	var land_use_in_2022 = GraphsData.get_data_for_year("land_use", Gameloop.start_year).value
	var land_use_now = GraphsData.get_data_for_year("land_use", Gameloop.start_year + Gameloop.current_turn * Gameloop.years_in_a_turn).value
	var land_use_diff_percentage = (land_use_now * 100.0 / land_use_in_2022) -100.0
	game_stats.land_use_diff_percentage = land_use_diff_percentage
	
	game_stats.implemented_policies_count = PolicyManager.get_implemented_policies_count()
	
	var imported_energy_amount = Gameloop.imported_energy_amount
	var total_winter_energy = Gameloop.supply_winter
	game_stats.imported_energy_percentage =  imported_energy_amount * 100.0 / total_winter_energy
	
	game_stats_updated.emit(game_stats)
	
	
func _on_show_ending_screen():
	show()


func _on_close_button_pressed():
	hide()


func _on_player_name_text_submitted(new_text):
	#Gameloop.player_name = new_text
	if new_text == "" or new_text == null:
		new_text = "new_player"
		%player_name.text = new_text
	Context.change_player_name(Context.res_id, new_text.uri_encode())
	%player_name.editable = false
	%NameEdit.hide()
	%player_name.release_focus()
	%NameEdit.button_pressed = false
	
	
func _on_player_name_changed():
	%player_name.editable = true
	%NameEdit.show()


func _on_name_edit_toggled(toggled_on):
	if toggled_on:
		%NameEdit.icon = tick_icon
		%player_name.grab_focus()
	else:
		%NameEdit.icon = pen_icon
		if %player_name.editable:
			%player_name.text_submitted.emit(%player_name.text)
			%player_name.release_focus()


func _on_player_name_focus_entered():
	%NameEdit.set_pressed_no_signal(true)
	%NameEdit.icon = tick_icon


func _on_player_name_focus_exited():
	%NameEdit.toggled.emit(false)


func _on_button_pressed():
	%NameInfoButton.hide()
	%player_name.grab_focus()


func _on_leaderboard_toggled(toggled_on: bool) -> void:
	$MainFrame/Screen/MetricsRanking/EndMessage.visible = not toggled_on
	$MainFrame/Screen/MetricsRanking/StatContainer.visible = toggled_on


func _on_summary_toggled(toggled_on: bool) -> void:
	$MainFrame/Screen/MetricsRanking/SummaryContainer.visible = toggled_on
	$MainFrame/Screen/MetricsRanking/EndMessage.visible = not toggled_on


func _on_metrics_leaderboard_updated(leaderboard) -> void:
	$MainFrame/Leaderboard.button_pressed = true
