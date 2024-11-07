extends CanvasLayer

signal window_opened

@onready var policy_buttons: Array[TextureButton] = [
	$Control/LeftFrame/campaign_env,
	$Control/LeftFrame/Upgrade_PV,
	$Control/LeftFrame/Wind_buildtime,
	$Control/LeftFrame/Upgrade_wind,
	$Control/RightFrame/campaign_demand,
	$Control/RightFrame/home_regulation,
	$Control/RightFrame/industry_subsidy,
]


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.toggle_policies_window.connect(_on_toggle_policies_window)
	PolicyManager.policy_button_unclicked.connect(func(): window_opened.emit())


func _on_toggle_policies_window():
	visible = not visible
	
	if visible:
		window_opened.emit()
		CameraManager.block_camera.emit()
		
	
	# Buttons stay pressed when closing the window, so we unpress them
	for button in policy_buttons:
		if not button.disabled:
			button.button_pressed = false
	
	show()


func _on_backdrop_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		CameraManager.unlock_camera.emit()
		hide()


func _on_close_button_pressed():
	CameraManager.unlock_camera.emit()
	hide()
