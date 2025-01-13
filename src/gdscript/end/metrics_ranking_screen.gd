extends Control

@export var button_group: ButtonGroup
var num = 0
var score_list = ["met_nuc", "met_fos", "met_ele", "met_emi", "met_lnd", "met_cst", "met_smr"]
var rank_list = ["rnk_nuc", "rnk_fos", "rnk_ele", "rnk_emi", "rnk_lnd", "rnk_cst", "rnk_smr"]
var metric_list = [" Tj", " Tj", " Tj", "M CO2/t", " Km2", "M CHF", "%"]
var player_new_name = null

func _ready():
	for button in button_group.get_buttons():
		button.connect("pressed", _on_leaderboard_button_pressed.bind(num))
		num += 1


func _on_graph_context_changed(context: String):
	visible = context == "none"


func _on_leaderboard_button_pressed(button_index):
	$RichTextLabel.hide()
	$StatContainer.show()
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
		
			
func _on_end_metrics_leaderboard_updated(leaderboard):
	$CalcRank.hide()
	#$StatContainer.show()
	#%NameInfoButton.show()
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
