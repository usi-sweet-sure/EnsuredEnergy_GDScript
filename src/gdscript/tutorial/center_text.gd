extends RichTextLabel

var tutorial_texts = ["TUTORIAL%d", "CLIMATE_TUTORIAL%d"]
var selected_tuto = 0
var current_step = 0

func _ready():
	selected_tuto = randi_range(0,1)
	TutorialManager.tutorial_started.connect(_on_tutorial_started)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_step_changed(step: int):
	current_step = step
	text = tr(tutorial_texts[selected_tuto] % current_step)


func _on_tutorial_started():
	TutorialManager.step_changed.connect(_on_step_changed)
	_on_step_changed(0)
	

func _on_tutorial_ended():
	TutorialManager.step_changed.disconnect(_on_step_changed)


func _on_locale_updated(_locale):
	text = tr(tutorial_texts[selected_tuto] % current_step)
