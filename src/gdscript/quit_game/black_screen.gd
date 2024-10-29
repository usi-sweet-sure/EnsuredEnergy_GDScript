extends TextureRect


@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $"../../AudioStreamPlayer"


func play_text():
	var text := tr("THANK_YOU_FOR_PLAYING")
	var text_array := text.split()
	
	while text_array.size() > 0:
		label.text += text_array[0]
		text_array.remove_at(0)
		audio_stream_player.pitch_scale = randf_range(1.1, 1.2)
		audio_stream_player.play()
		await get_tree().create_timer(0.04).timeout
		
