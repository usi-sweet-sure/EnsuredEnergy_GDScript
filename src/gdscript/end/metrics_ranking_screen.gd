extends Control

@export var button_group: ButtonGroup
@export var summary_button: ButtonGroup
@onready var co_2_summary: Control = $SummaryContainer/CO2Summary
var num = 0
var score_list = ["met_nuc", "met_fos", "met_ele", "met_emi", "met_lnd", "met_cst", "met_smr"]
var rank_list = ["rnk_nuc", "rnk_fos", "rnk_ele", "rnk_emi", "rnk_lnd", "rnk_cst", "rnk_smr"]
var metric_list = [" Tj", " Tj", " Tj", "M CO2/t", " Km2", "M CHF", "%"]
var summary_texts_1 = ["NETZERO_TEXT", "LANDUSE_TEXT", "NUC_TEXT", "NO_MONEY_TEXT", "POLICIES_TEXT", "IMPORT_TEXT"]
var summary_texts_2 = ["", "", "", "", "", ""]
var game_stats = null
var score_info_list = ["NUCLEAR_SCORE", "FOSSIL_SCORE", "ENERGY_SCORE", "EMISSIONS_SCORE", "LAND_USE_SCORE", "PROD_COST_SCORE", "SEASONALITY_SCORE"]
var player_new_name = null


func _ready():
	for button in button_group.get_buttons():
		button.connect("pressed", _on_leaderboard_button_pressed.bind(num))
		num += 1
		
	num = 0
	for button in summary_button.get_buttons():
		button.connect("pressed", _on_summary_button_pressed.bind(num))
		num += 1


func _on_graph_context_changed(context: String):
	visible = context == "none"


func _on_leaderboard_button_pressed(button_index):
	$EndMessage.hide()
	$StatContainer.show()
	$StatContainer/VBoxContainer/PlayerStats2/Score_info.text = score_info_list[button_index]
	num = 0
	for i in Context.leaderboard_json[button_index]:
		num += 1
		var name_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/NAME")
		var score_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/SCORE")
		var rank_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/RANK")
		name_node.text = _assert_not_null(i["res_name"])
		score_node.text = _assert_not_null(i[score_list[button_index]]).pad_decimals(2) + metric_list[button_index]
		rank_node.text = _assert_not_null(i[rank_list[button_index]])
		%player_score.text = _assert_not_null(Context.rank_json[0][score_list[button_index]]).pad_decimals(2) + metric_list[button_index]
		%player_rank.text = _assert_not_null(Context.rank_json[0][rank_list[button_index]])
		%player_name.release_focus()
		#if player_new_name != null:
			#%player_name.text = player_new_name
		#else:
			#%player_name.text = _assert_not_null(Context.rank_json[0]["res_name"])
		
			
func _on_summary_button_pressed(button_index):
	$SummaryContainer/VBoxContainer/SummaryText/Label.text = summary_texts_1[button_index]
	$SummaryContainer/VBoxContainer/SummaryText/Label2.text = summary_texts_2[button_index]

	if button_index == 0:
		$SummaryContainer/VBoxContainer/SummaryText/Label2.show()
		co_2_summary.show()
	else:
		$SummaryContainer/VBoxContainer/SummaryText/Label2.hide()
		co_2_summary.hide()
		
			
func _on_end_metrics_leaderboard_updated(leaderboard):
	$CalcRank.hide()
	#$StatContainer.show()
	%NameInfoButton.show()
	$StatContainer/VBoxContainer/PlayerStats2/Score_info.text = score_info_list[2]
	num = 0
	for i in leaderboard[2]:
		num += 1
		var name_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/NAME")
		var score_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/SCORE")
		var rank_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/RANK")
		name_node.text = _assert_not_null(i["res_name"])
		score_node.text = _assert_not_null(i["met_ele"]).pad_decimals(2) + metric_list[2]
		rank_node.text = _assert_not_null(i["rnk_ele"])


func _on_end_metrics_rank_updated(rank):
	%player_name.text = _assert_not_null(rank[0]["res_name"])
	%player_score.text = _assert_not_null(rank[0]["met_ele"]).pad_decimals(2) + metric_list[2]
	%player_rank.text = _assert_not_null(rank[0]["rnk_ele"])


func _assert_not_null(val: Variant):
	if val == null:
		return ""
	else:
		return val


func _on_player_name_text_submitted(new_text: String) -> void:
	player_new_name = new_text
	


func _on_game_stats_updated(_game_stats: Dictionary) -> void:
	game_stats = _game_stats
	var summary_buttons = summary_button.get_buttons()
	
	# Emissions
	var emissions_button: Button = summary_buttons[0]
	if game_stats.reached_net_zero:
		summary_texts_1[0] = tr("NETZERO_TEXT")
		emissions_button.add_theme_color_override("icon_normal_color", Color("00a522"))
		emissions_button.add_theme_color_override("icon_hover_color", Color("00a522"))
		emissions_button.add_theme_color_override("icon_pressed_color", Color("00a522"))
	else:
		summary_texts_1[0] = tr("NO_NETZERO_TEXT")
		emissions_button.add_theme_color_override("icon_normal_color", Color("f62a33"))
		emissions_button.add_theme_color_override("icon_hover_color", Color("f62a33"))
		emissions_button.add_theme_color_override("icon_pressed_color", Color("f62a33"))
		
	if game_stats.emissions_diff_percentage < 0:
		var value = str(abs(game_stats.emissions_diff_percentage)).pad_decimals(2)
		summary_texts_2[0] = tr("CO2_TEXT").format([value], "&&")
	else:
		var value = str(game_stats.emissions_diff_percentage).pad_decimals(2)
		summary_texts_2[0] = tr("NO_CO2_TEXT").format([value], "&&")

	# Landuse
	if game_stats.land_use_diff_percentage < 0:
		var value = str(abs(game_stats.land_use_diff_percentage)).pad_decimals(2)
		summary_texts_1[1] = tr("LANDUSE_TEXT").format([value], "&&")
	else:
		var value = str(game_stats.land_use_diff_percentage).pad_decimals(2)
		summary_texts_1[1] = tr("NO_LANDUSE_TEXT").format([value], "&&")
	
	# Nuclear
	var nuclear_button: Button = summary_buttons[2]
	if game_stats.nuclear_energy_percentage > 0:
		var value = str(abs(game_stats.nuclear_energy_percentage)).pad_decimals(2)
		summary_texts_1[2] = tr("NUC_TEXT").format([value], "&&")
		nuclear_button.add_theme_color_override("icon_normal_color", Color("f62a33"))
		nuclear_button.add_theme_color_override("icon_hover_color", Color("f62a33"))
		nuclear_button.add_theme_color_override("icon_pressed_color", Color("f62a33"))
	else:
		summary_texts_1[2] = tr("NO_NUC_TEXT")
		nuclear_button.add_theme_color_override("icon_normal_color", Color("00a522"))
		nuclear_button.add_theme_color_override("icon_hover_color", Color("00a522"))
		nuclear_button.add_theme_color_override("icon_pressed_color", Color("00a522"))
	
	if game_stats.production_costs_diff_percentage < 0:
		var value = str(abs(game_stats.production_costs_diff_percentage)).pad_decimals(2)
		summary_texts_1[3] = tr("MONEY_TEXT").format([value], "&&")
	else:
		var value = str(game_stats.production_costs_diff_percentage).pad_decimals(2)
		summary_texts_1[3] = tr("NO_MONEY_TEXT").format([value], "&&")

	summary_texts_1[4] = tr("POLICIES_TEXT").format([game_stats.implemented_policies_count], "&&")
	
	if game_stats.imported_energy_percentage > 0:
		var value = str(game_stats.imported_energy_percentage).pad_decimals(2)
		summary_texts_1[5] = tr("IMPORT_TEXT").format([value], "&&")
	else:
		summary_texts_1[5] = tr("NO_IMPORT_TEXT")
		
	_on_summary_button_pressed(0)
