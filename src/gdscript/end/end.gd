extends CanvasLayer


@onready var leaderboard = $EndWindow/Leaderboard

func _on_score_toggled(toggled_on):
	$EndWindow.visible = !toggled_on
