extends Control


func _on_graph_context_changed(context: String):
	visible = context == "none"


var num = 0


func _on_end_metrics_leaderboard_updated(leaderboard):
	$RichTextLabel.hide()
	$StatContainer.show()
	for i in leaderboard:
		num += 1
		var name_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/NAME")
		var score_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/SCORE")
		var rank_node = get_node("/root/Main/End/MainFrame/Screen/MetricsRanking/StatContainer/VBoxContainer/Rank" + str(num) + "/HBoxContainer/RANK")
		name_node.text = i["res_name"]
		score_node.text = i["met_nuc"]
		rank_node.text = i["rnk_nuc"]


func _on_end_metrics_rank_updated(rank):
	%player_name.text = rank[0]["res_name"]
	%player_score.text = rank[0]["met_nuc"]
	%player_rank.text = rank[0]["rnk_nuc"]
