extends CanvasLayer

@onready var explanation = $Control/CenterFrame/Explanation
@onready var policy_description = $Control/CenterFrame/Description
@onready var policy_effect = $Control/CenterFrame/Effect
@onready var vote_zone = $Control/CenterFrame/Vote


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.policy_button_clicked.connect(_on_policy_button_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_open_policies_window_button_pressed():
	explanation.show()
	policy_description.hide()
	policy_effect.hide()
	vote_zone.hide()
	show()
	

func _on_policy_button_clicked(policy_id):
	explanation.hide()


func _on_backdrop_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		hide()
