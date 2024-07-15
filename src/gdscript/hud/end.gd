extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_score_toggled(toggled_on):
	$EndWindow.visible = !toggled_on
