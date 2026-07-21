extends Control

signal summary_requested(type: String)

@export var leaderboard_buttons: ButtonGroup
@export var summary_buttons: ButtonGroup
@onready var per_plant_summary: Control = $BackPanel/Screen/Summary/PerPlantSummary
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var score_list = ["met_nuc", "met_fos", "met_ele", "met_emi", "met_lnd", "met_cst", "met_smr"]
var rank_list = ["rnk_nuc", "rnk_fos", "rnk_ele", "rnk_emi", "rnk_lnd", "rnk_cst", "rnk_smr"]
var metric_list = [" Tj", " Tj", " Tj", "M CO2/t", " Km2", "M CHF", "%"]
var summary_texts_1 = ["NETZERO_TEXT", "LANDUSE_TEXT", "NUC_TEXT", "NO_MONEY_TEXT", "POLICIES_TEXT", "IMPORT_TEXT"]
var summary_texts_2 = ["", "", "", "", "", ""]
var game_stats = null
var score_info_list = ["NUCLEAR_SCORE", "FOSSIL_SCORE", "ENERGY_SCORE", "EMISSIONS_SCORE", "LAND_USE_SCORE", "PROD_COST_SCORE", "SEASONALITY_SCORE"]
var first_time_toggling_end = true

func _ready():
	Gameloop.player_name_updated.connect(_on_player_name_updated)
	Gameloop.end_toggled.connect(_on_end_toggled)
	hide()
	$BackPanel/Screen/Leaderboard.hide()
	$BackPanel/Screen/Summary.hide()
	$SummaryButton.button_pressed = true
	
	var button_index = 0
	for button in leaderboard_buttons.get_buttons():
		button.connect("pressed", _on_leaderboard_button_pressed.bind(button_index))
		button_index += 1
		
	button_index = 0
	for button in summary_buttons.get_buttons():
		button.connect("pressed", _on_summary_button_pressed.bind(button_index))
		button_index += 1


func _on_leaderboard_button_pressed(button_index):
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats2/Score_info.text = score_info_list[button_index]
	var tab = 0
	for i in Context.leaderboard_json[button_index]:
		tab += 1
		var name_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(tab) + "/HBoxContainer/NAME")
		var score_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(tab) + "/HBoxContainer/SCORE")
		var rank_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(tab) + "/HBoxContainer/RANK")
		name_node.text = _assert_not_null(i["res_name"])
		score_node.text = _assert_not_null(i[score_list[button_index]]).pad_decimals(2) + metric_list[button_index]
		rank_node.text = _assert_not_null(i[rank_list[button_index]])
		$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_score.text = _assert_not_null(Context.rank_json[0][score_list[button_index]]).pad_decimals(2) + metric_list[button_index]
		$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_rank.text = _assert_not_null(Context.rank_json[0][rank_list[button_index]])
		
			
func _on_summary_button_pressed(button_index):
	var summary_types = ["emissions", "land_use", "nuclear", "money", "politics", "energy"]
	summary_requested.emit(summary_types[button_index])
	$BackPanel/Screen/Summary/VBoxContainer/SummaryText/Label.text = summary_texts_1[button_index]
	$BackPanel/Screen/Summary/VBoxContainer/SummaryText/Label2.text = summary_texts_2[button_index]

	if button_index == 0:
		$BackPanel/Screen/Summary/VBoxContainer/SummaryText/Label2.show()
	else:
		$BackPanel/Screen/Summary/VBoxContainer/SummaryText/Label2.hide()
	
	if button_index == 0 or button_index == 1 or button_index == 3 or button_index == 5:
		per_plant_summary.show()
	else:
		per_plant_summary.hide()
		
			
func _on_leaderboard_updated(leaderboard):
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats2/Score_info.text = score_info_list[2]
	var button_index = 0
	for i in leaderboard[2]:
		button_index += 1
		var name_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(button_index) + "/HBoxContainer/NAME")
		var score_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(button_index) + "/HBoxContainer/SCORE")
		var rank_node = get_node("BackPanel/Screen/Leaderboard/VBoxContainer/Rank" + str(button_index) + "/HBoxContainer/RANK")
		name_node.text = _assert_not_null(i["res_name"])
		score_node.text = _assert_not_null(i["met_ele"]).pad_decimals(2) + metric_list[2]
		rank_node.text = _assert_not_null(i["rnk_ele"])
		

func _on_rank_updated(rank):
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_name.text = _assert_not_null(rank[0]["res_name"])
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_score.text = _assert_not_null(rank[0]["met_ele"]).pad_decimals(2) + metric_list[2]
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_rank.text = _assert_not_null(rank[0]["rnk_ele"])


func _assert_not_null(val: Variant):
	if val == null:
		return ""
	else:
		return val
	

func _on_game_stats_updated(_game_stats: Dictionary) -> void:
	game_stats = _game_stats
	var summary_buttons = summary_buttons.get_buttons()
	
	# Emissions
	var emissions_button: Button = summary_buttons[0]
	if game_stats.reached_net_zero:
		summary_texts_1[0] = tr("NETZERO_TEXT")
	else:
		summary_texts_1[0] = tr("NO_NETZERO_TEXT")
		
	var diff = str(abs(int(round(game_stats.emissions_diff_percentage))))
	var sequestrated = str(int(round(game_stats.sequestrated_co2_percentage)))
	
	if game_stats.emissions_diff_percentage < 0:
		summary_texts_2[0] = tr("CO2_TEXT").format([diff], "&&") + "\n" + tr("SEQUESTRATED_CO2").format([sequestrated], "&&")
	else:
		summary_texts_2[0] = tr("NO_CO2_TEXT").format([diff], "&&") + "\n" + tr("SEQUESTRATED_CO2").format([sequestrated], "&&")

	# Landuse
	if game_stats.land_use_diff_percentage < 0:
		var value = str(abs(int(round(game_stats.land_use_diff_percentage))))
		summary_texts_1[1] = tr("LANDUSE_TEXT").format([value], "&&")
	else:
		var value = str(int(round(game_stats.land_use_diff_percentage)))
		summary_texts_1[1] = tr("NO_LANDUSE_TEXT").format([value], "&&")
	
	# Nuclear
	var nuclear_button: Button = summary_buttons[2]
	if game_stats.nuclear_energy_percentage > 0:
		var value = str(abs(int(round(game_stats.nuclear_energy_percentage))))
		summary_texts_1[2] = tr("NUC_TEXT").format([value], "&&")
	else:
		summary_texts_1[2] = tr("NO_NUC_TEXT")
	
	if game_stats.production_costs_diff_percentage < 0:
		var value = str(abs(int(round(game_stats.production_costs_diff_percentage))))
		summary_texts_1[3] = tr("MONEY_TEXT").format([value], "&&")
	else:
		var value = str(int(round(game_stats.production_costs_diff_percentage)))
		summary_texts_1[3] = tr("NO_MONEY_TEXT").format([value], "&&")

	summary_texts_1[4] = tr("POLICIES_TEXT").format([game_stats.implemented_policies_count], "&&")
	
	if game_stats.imported_energy_percentage > 0:
		var value = str(int(round(game_stats.imported_energy_percentage)))
		summary_texts_1[5] = tr("IMPORT_TEXT").format([value], "&&")
	else:
		summary_texts_1[5] = tr("NO_IMPORT_TEXT")
		
	_on_summary_button_pressed(0)
	

func _on_leaderboard_toggled(toggled_on: bool) -> void:
	$BackPanel/Screen/Leaderboard.visible = toggled_on


func _on_summary_toggled(toggled_on: bool) -> void:
	$BackPanel/Screen/Summary.visible = toggled_on
	

# Next button from previous screen, leading to this one
func _on_next_button_pressed() -> void:
	animation_player.play("summary_appears")


func _on_player_name_updated(value: String)  -> void:
	$BackPanel/Screen/Leaderboard/VBoxContainer/PlayerStats/HBoxContainer/player_name.text = value


func _on_show_map_toggled(toggled_on: bool) -> void:
	Gameloop.end_toggled.emit(toggled_on)


func _on_end_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("show_map")
		CameraManager.unlock_camera.emit()
	else:
		animation_player.play("summary_appears_2")
		PowerplantsManager.unfocus_all.emit()
		CameraManager.reset_camera.emit()
		CameraManager.block_camera.emit()
