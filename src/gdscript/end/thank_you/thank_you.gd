extends Control

signal text_written(index: int)

@onready var back_panel: TextureRect = $BackPanel
@onready var thank_you_label: Label = $BackPanel/Screen/ThankYouLabel
@onready var game_done_label: Label = $BackPanel/Screen/GameDoneLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var summary_label: Label = $BackPanel/Screen/SummaryLabel
@onready var next_button: TextureButton = $NextButton


func _ready() -> void:
	back_panel.hide()
	thank_you_label.hide()
	game_done_label.hide()
	summary_label.hide()
	next_button.hide()
	Gameloop.game_ended.connect(_on_game_ended)
		
	
func _on_game_ended():
	animation_player.play("screen_appears")
	animation_player_2.play("next_button_modulates")
	await animation_player.animation_finished
	play_text(thank_you_label, 0)
	

func play_text(label: Label, index: int) -> void:
	var text = tr(label.text)
	label.text = ""
	var text_array := text.split()
	label.show()
	
	while text_array.size() > 0:
		label.text += text_array[0]
		text_array.remove_at(0)
		#audio_stream_player.pitch_scale = randf_range(1.1, 1.2)
		#audio_stream_player.play()
		await get_tree().create_timer(0.02).timeout
	
	text_written.emit(index)


func _on_text_written(index: int) -> void:
	if index == 0:
		play_text(game_done_label, 1)
	elif index == 1:
		play_text(summary_label, 2)
	else:
		animation_player.play("next_button_appears")


func _on_leaderboard_updated(_leaderboard) -> void:
	next_button.disabled = false
	animation_player_2.stop() # Next button stops modulating
	next_button.get_node("Label").text = tr("TO_SUMMARY")
	next_button.get_node("LoadingIndicator").hide()
