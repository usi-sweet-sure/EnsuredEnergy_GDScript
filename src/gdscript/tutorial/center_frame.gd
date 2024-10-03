extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	TutorialManager.tutorial_started.connect(_on_tutorial_started)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)


func _on_tutorial_started():
	show()
	TutorialManager.step_changed.connect(_on_step_changed)


func _on_tutorial_ended():
	TutorialManager.step_changed.disconnect(_on_step_changed)


func _on_step_changed(step: int):
	visible = not (step == 3 or step == 4 or step == 5)
