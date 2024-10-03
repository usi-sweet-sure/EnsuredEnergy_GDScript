extends CanvasLayer

var step = 0
var tuto_length = 11

@onready var center_frame = $CenterFrame


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	TutorialManager.tutorial_started.connect(_on_tutorial_started)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)

func _on_next_step_requested():
	if step < tuto_length:
		step += 1
		print("tuto index: ", step)

		TutorialManager.step_changed.emit(step)
	else:
		TutorialManager.tutorial_ended.emit()


func _on_tutorial_started():
	step = 0
	TutorialManager.next_step_requested.connect(_on_next_step_requested)
	PowerplantsManager.powerplant_build_requested.connect(_on_pp_build)
	Gameloop.toggle_policies_window.connect(_on_policies_toggled)
	
	show()


func _on_tutorial_ended():
	hide()
	TutorialManager.next_step_requested.disconnect(_on_next_step_requested)
	PowerplantsManager.powerplant_build_requested.disconnect(_on_pp_build)
	Gameloop.toggle_policies_window.disconnect(_on_policies_toggled)


func _on_pp_build(_map_emplacement: PpMapEmplacement, _metrics: PowerplantMetrics):
	_on_next_step_requested()


func _on_policies_toggled():
	_on_next_step_requested()
