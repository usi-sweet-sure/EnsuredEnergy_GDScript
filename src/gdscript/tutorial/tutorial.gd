extends CanvasLayer

const NEXT_ANIMATION_A := "next__0_out_1_in"
const NEXT_ANIMATION_B := "next__1_out_0_in"
const PREVIOUS_ANIMATION_A := "previous__1_out_0_in"
const PREVIOUS_ANIMATION_B := "previous__0_out_1_in"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var text_0: RichTextLabel = $Frame0/Screen/Text0
@onready var text_1: RichTextLabel = $Frame0/Screen/Text1
@onready var previous_button: TextureButton = $Buttons/NavigationButtons/Buttons/Previous
@onready var step_indicator_label: Label = $StepIndicator/Label


var step = 0
var previous_step = 0
var tuto_length = 11
var futur_next_animation := NEXT_ANIMATION_A
var futur_previous_animation := PREVIOUS_ANIMATION_A
var previous_survey_frame = 1
var current_text = 0
var texts: Array[String] = [
	"CLIMATE_TUTORIAL0",  # Step0
	"CLIMATE_TUTORIAL1",  # Step1
	"CLIMATE_TUTORIAL2",  # Step2
	"TUTOBUBBLE0",        # Step3
	"CLIMATE_TUTORIAL4",  # Step4
	"TUTOBUBBLE1",        # Step5
	"TUTOBUBBLE2",        # Step6
	"CLIMATE_TUTORIAL7",  # Step7
	"TUTOBUBBLE3",        # Step8
	"TUTOBUBBLE4",        # Step9
	"CLIMATE_TUTORIAL10", # Step10
	"TUTOBUBBLE6",        # Step11
	"TUTORIAL_0",         # Step12
]
var steps_with_no_navigation_button := [5, 8, 9, 11]
var camera_config_for_step := [
	null,  # Step0
	null,  # Step1
	null,  # Step2
	null,  # Step3
	null,  # Step4
	null,  # Step5
	null,  # Step6
	null,  # Step7
	[Vector2(1376.407, 407.5414), Vector2(0.6, 0.6)], # Step8
	[Vector2(1376.407, 407.5414), Vector2(0.6, 0.6)], # Step9
	null, # Step10
	null, # Step11
	null, # Step12
]


func _ready():
	hide()
	TutorialManager.tutorial_started.connect(_on_tutorial_started)
	TutorialManager.tutorial_ended.connect(_on_tutorial_ended)
	SurveyManager.frame_updated.connect(_on_frame_updated)
	Gameloop.locale_updated.connect(_on_locale_updated)
	_on_frame_updated(SurveyManager.frame)
	
	
func _on_tutorial_started():
	step = 0
	previous_step = 0
	current_text = 0
	text_0.text = tr(texts[step])
	_update_previous_button_state(step)
	_update_step_indicator_state()
	TutorialManager.next_step_requested.connect(_on_next_step_requested)
	PowerplantsManager.powerplant_build_requested.connect(_on_pp_build)
	Gameloop.toggle_policies_window.connect(_on_policies_toggled)
	
	show()
	
	animation_player_2.play("RESET")
	animation_player.play("tutorial_starts")
	

func _on_next_step_requested():
	if step < tuto_length:
		previous_step = step
		step += 1
		TutorialManager.step_changed.emit(step)
		_update_previous_button_state(step)
		_play_animation()
		_update_step_indicator_state()
		_update_camera_state()
	else:
		TutorialManager.tutorial_ended.emit()
		

func _on_previous_step_requested():
	if step > 0:
		previous_step = step
		step -= 1
		TutorialManager.step_changed.emit(step)
		_update_previous_button_state(step)
		_update_step_indicator_state()
		_play_animation(false)
		_update_camera_state()


func _on_tutorial_ended():
	hide()
	TutorialManager.next_step_requested.disconnect(_on_next_step_requested)
	PowerplantsManager.powerplant_build_requested.disconnect(_on_pp_build)
	Gameloop.toggle_policies_window.disconnect(_on_policies_toggled)


func _on_pp_build(_map_emplacement: PpMapEmplacement, _metrics: PowerplantMetrics):
	_on_next_step_requested()


func _on_policies_toggled():
	_on_next_step_requested()
	
	
func _play_animation(forward: bool = true) -> void:
	var animation = futur_next_animation
	var hide_navigation_buttons = steps_with_no_navigation_button.has(step) and not steps_with_no_navigation_button.has(previous_step)
	var show_navigation_buttons = steps_with_no_navigation_button.has(previous_step) and not steps_with_no_navigation_button.has(step)
	
	if not forward:
		animation = futur_previous_animation
	
	if animation == NEXT_ANIMATION_A or animation == PREVIOUS_ANIMATION_B:
		# Text_0 is going out and Text_1 is coming in,
		# So text_1 is the new text
		text_1.text = tr(texts[step])
		current_text = 1
		
		futur_next_animation = NEXT_ANIMATION_B
		futur_previous_animation = PREVIOUS_ANIMATION_A
	elif animation == NEXT_ANIMATION_B or animation == PREVIOUS_ANIMATION_A:
		# Text_1 is going out and Text_0 is coming in,
		# So text_0 is the new text
		text_0.text = tr(texts[step])
		current_text = 0
		
		futur_next_animation = NEXT_ANIMATION_A
		futur_previous_animation = PREVIOUS_ANIMATION_B
		
	animation_player.play(animation)
	
	if hide_navigation_buttons:
		animation_player_2.play("hide_navigation_buttons")
	elif show_navigation_buttons:
		animation_player_2.play("show_navigations_buttons")
	

func _on_frame_updated(survey_frame: int) -> void:
	var index = 0
	# 0 is TUTORIAL, 1 is CLIMATE_TUTORIAL
	for key in texts:
		if survey_frame == 0 and previous_survey_frame == 1:
			texts[index] = key.replace("CLIMATE_TUTORIAL", "TUTORIAL")
		elif survey_frame == 1 and previous_survey_frame == 0:
			texts[index] = key.replace("TUTORIAL", "CLIMATE_TUTORIAL")
		index += 1
		
	previous_survey_frame = survey_frame

	if step == 0:
		text_0.text = tr(texts[step])
		

func _on_locale_updated(_locale):
	if current_text == 0:
		text_0.text = tr(texts[step])
	else:
		text_1.text = tr(texts[step])


func _on_skip_button_pressed() -> void:
	TutorialManager.tutorial_ended.emit()
	

func _update_previous_button_state(step: int):
	var disable_button = not step > 0
	previous_button.disabled = disable_button
	
	if disable_button:
		previous_button.remove_from_group("buttons")
		previous_button.add_to_group("disabled_buttons")
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
	else:
		previous_button.remove_from_group("disabled_buttons")
		previous_button.add_to_group("buttons")
		GroupManager.buttons_group_updated.emit()
		GroupManager.disabled_buttons_group_updated.emit()
	

func _update_step_indicator_state():
	step_indicator_label.text = str(step + 1) + " / " + str(tuto_length + 1)


func _update_camera_state():
	var new_state = camera_config_for_step[step]
	
	if new_state != null:
		CameraManager.unlock_camera.emit()
		CameraManager.move_camera_to.emit(new_state[0])
		CameraManager.zoom_camera_to.emit(new_state[1])
		CameraManager.block_camera.emit()
	else:
		CameraManager.unlock_camera.emit()
		CameraManager.reset_camera.emit()
