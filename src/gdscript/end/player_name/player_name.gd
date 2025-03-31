extends Control

@onready var button_label: Label = $NextButton/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_input: LineEdit = $BackPanel/Screen/LineEdit


func _ready() -> void:
	hide()


func _on_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		button_label.text = tr("VALIDATE")
	else:
		button_label.text = tr("SKIP")


# Next button from previous screen, leading to this one
func _on_next_button_pressed() -> void:
	name_input.grab_focus()
	animation_player.play("player_name_appears")
	
	
# Next button from this screen, which should submit the name
func _on_this_next_button_pressed() -> void:
	name_input.text_submitted.emit(name_input.text)
	

func _on_text_submitted(new_text: String) -> void:
	if new_text == "" or new_text == null:
		new_text = "new_player"
		
	Context.change_player_name(Context.res_id, new_text.uri_encode())
	Gameloop.player_name = new_text
