extends Control

@onready var button_label: Label = $NextButton/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_input: LineEdit = $BackPanel/Screen/LineEdit
@onready var keyboard_sound: AudioStreamPlayer = $KeyboardSound
@onready var unallowed_label: Label = $BackPanel/Screen/UnallowedLabel
@onready var next_button: TextureButton = $NextButton

var banned_words := {}

func _ready() -> void:
	hide()
	unallowed_label.hide()
	_load_word_file("res://profanity/en.txt")
	_load_word_file("res://profanity/fr.txt")
	_load_word_file("res://profanity/de.txt")
	_load_word_file("res://profanity/it.txt")


func _on_text_changed(new_text: String) -> void:
	keyboard_sound.pitch_scale = randf_range(0.9, 1.0)

	keyboard_sound.play()
	if new_text.length() > 0:
		if new_text.length() >= 3 and not _is_username_allowed(new_text):
			unallowed_label.show()
			button_label.text = tr("VALIDATE")
			next_button.disabled = true
		else:
			unallowed_label.hide()
			button_label.text = tr("VALIDATE")
			next_button.disabled = false
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
	if new_text == "" or new_text == null or (new_text.length() >= 3 and not _is_username_allowed(new_text)):
		new_text = "new_player"
		
	Context.change_player_name(Context.res_id, new_text.uri_encode())
	Gameloop.player_name = new_text

func _is_username_allowed(username: String) -> bool:
	return !banned_words.has(username.to_lower())

	
func _load_word_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return

	while !file.eof_reached():
		var word := file.get_line().strip_edges().to_lower()
		if word != "":
			banned_words[word] = true
	
	
