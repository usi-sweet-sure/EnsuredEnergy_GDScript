extends Node


@onready var forest_ambiance: AudioStreamPlayer = $ForestAmbiance
@onready var water: AudioStreamPlayer2D = $Water
@onready var water_2: AudioStreamPlayer2D = $Water2
@onready var wind: AudioStreamPlayer2D = $Wind
@onready var dark_fantasy: AudioStreamPlayer = $DarkFantasy
@onready var button_hover = $ButtonHover
@onready var button_press = $ButtonPress
@onready var button_error = $ButtonError
@onready var input_entered = $InputEntered
@onready var paper_open = $PaperOpen
@onready var paper_close = $PaperClose
@onready var switch_toggle = $SwitchToggle
@onready var paper_manip = $PaperManip


func _ready():
	#dark_fantasy.play()
	Gameloop.game_started.connect(_on_game_started)
	Gameloop.game_ended.connect(_on_game_ended)
	GroupManager.buttons_group_updated.connect(_on_buttons_group_updated)
	GroupManager.disabled_buttons_group_updated.connect(_on_disabled_buttons_group_updated)
	GroupManager.switches_group_updated.connect(_on_switches_group_updated)
	_on_buttons_group_updated()
	_on_disabled_buttons_group_updated()
	_on_more_help_buttons_group_updated()
	_on_inputs_group_updated()
	_on_papers_group_updated()
	_on_switches_group_updated()


func _on_game_started():
	forest_ambiance.play()
	#$AnimationPlayer.play("fade_out")
	

func _on_game_ended():
	dark_fantasy.volume_db = 0
	#dark_fantasy.play()
	# animation player fade in
	forest_ambiance.stop()


func _on_button_mouse_entered():
	button_hover.play()


func _on_button_pressed():
	button_press.play()
	
	
func _on_more_help_button_mouse_entered():
	button_hover.play()


func _on_more_help_button_pressed():
	paper_manip.play()
	
	
func _on_disabled_buttons_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		button_error.play()

			
func _on_input_focus_entered():
	input_entered.play()


func _on_paper_draw():
	paper_open.play()


func _on_paper_hidden():
	paper_close.play()


func _on_switch_toggled(_toggled: bool):
	switch_toggle.play()


func _on_buttons_group_updated():
	var buttons: Array = get_tree().get_nodes_in_group("buttons")
	
	for button in buttons:
		if not button.mouse_entered.is_connected(_on_button_mouse_entered):
			button.mouse_entered.connect(_on_button_mouse_entered)
		
		if not button.pressed.is_connected(_on_button_pressed):
			button.pressed.connect(_on_button_pressed)
			
		if button.gui_input.is_connected(_on_disabled_buttons_gui_input):
			button.gui_input.disconnect(_on_disabled_buttons_gui_input)
		
		
func _on_disabled_buttons_group_updated():
	var disabled_buttons: Array = get_tree().get_nodes_in_group("disabled_buttons")
	
	for button in disabled_buttons:
		if not button.gui_input.is_connected(_on_disabled_buttons_gui_input):
			button.gui_input.connect(_on_disabled_buttons_gui_input)
			
		if button.mouse_entered.is_connected(_on_button_mouse_entered):
			button.mouse_entered.disconnect(_on_button_mouse_entered)
		
		if button.pressed.is_connected(_on_button_pressed):
			button.pressed.disconnect(_on_button_pressed)
			
			
func _on_inputs_group_updated():
	var inputs: Array = get_tree().get_nodes_in_group("inputs")
	
	for input in inputs:
		if not input.focus_entered.is_connected(_on_input_focus_entered):
			input.focus_entered.connect(_on_input_focus_entered)
	
			
func _on_papers_group_updated():
	var papers: Array = get_tree().get_nodes_in_group("papers")
	
	for paper in papers:
		if not paper.draw.is_connected(_on_paper_draw):
			paper.draw.connect(_on_paper_draw)
			
		if not paper.hidden.is_connected(_on_paper_hidden):
			paper.hidden.connect(_on_paper_hidden)
	

func _on_switches_group_updated():
	var switches: Array = get_tree().get_nodes_in_group("switches")
	
	for switch in switches:
		if not switch.toggled.is_connected(_on_switch_toggled):
			switch.toggled.connect(_on_switch_toggled)
			
			
func _on_more_help_buttons_group_updated():
	var buttons: Array = get_tree().get_nodes_in_group("more_help_buttons")
	
	for button in buttons:
		if not button.mouse_entered.is_connected(_on_more_help_button_mouse_entered):
			button.mouse_entered.connect(_on_more_help_button_mouse_entered)
		
		if not button.pressed.is_connected(_on_more_help_button_pressed):
			button.pressed.connect(_on_more_help_button_pressed)
			
		if button.gui_input.is_connected(_on_disabled_buttons_gui_input):
			button.gui_input.disconnect(_on_disabled_buttons_gui_input)
