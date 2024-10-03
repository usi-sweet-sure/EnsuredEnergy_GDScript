extends Control

@export var button_group: ButtonGroup
var num = 0
var score_list = ["met_nuc", "met_fos", "met_ele", "met_emi", "met_lnd", "met_cst", "met_smr"]
var rank_list = ["rnk_nuc", "rnk_fos", "rnk_ele", "rnk_emi", "rnk_lnd", "rnk_cst", "rnk_smr"]


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
	for i in Context1.leaderboard_json[button_index]:
		num += 1
		var name_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/NAME")
		var score_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/SCORE")
		var rank_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/RANK")
		name_node.text = i["res_name"]
		score_node.text = i[score_list[button_index]]
		rank_node.text = i[rank_list[button_index]]
		%player_name.text = Context1.rank_json[0]["res_name"]
		%player_score.text = Context1.rank_json[0][score_list[button_index]]
		%player_rank.text = Context1.rank_json[0][rank_list[button_index]]


func _on_end_metrics_leaderboard_updated(leaderboard):
	$RichTextLabel.hide()
	$StatContainer.show()
	num = 0
	for i in leaderboard[2]:
		num += 1
		var name_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/NAME")
		var score_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/SCORE")
		var rank_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/RANK")
		name_node.text = i["res_name"]
		score_node.text = i["met_ele"]
		rank_node.text = i["rnk_ele"]


func _on_end_metrics_rank_updated(rank):
	%player_name.text = rank[0]["res_name"]
	%player_score.text = rank[0]["met_ele"]
	%player_rank.text = rank[0]["rnk_ele"]
