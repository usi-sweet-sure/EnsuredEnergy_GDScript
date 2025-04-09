extends CanvasLayer

var lang := ["de", "fr", "it", "en"]
var i = 0
@onready var hud: CanvasLayer = $CanvasLayer
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
# Using two identical animation players so we can blend two animations
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var neon_flickers: AudioStreamPlayer = $NeonFlickers
@onready var play_button: TextureButton = $CanvasLayer/Buttons/PlayButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.player_can_start_playing_first_turn.connect(_on_player_can_start_playing)
	if SurveyManager.locale == "":
		TranslationServer.set_locale("de")
		Gameloop.locale_updated.emit("de")
	else:
		TranslationServer.set_locale(SurveyManager.locale)
		Gameloop.locale_updated.emit(SurveyManager.locale)
		
	animation_player.play("menu_apparition")
	await animation_player.animation_finished
	animation_player.play("menu_idle")
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_play_pressed():
	play_button.disabled = true
	animation_player.play("menu_goes_away_phase_1")
	await  animation_player.animation_finished
	animation_player.play("menu_goes_away_phase_2")
	# Let the animation play for a bit, in case the http request is done too quickly
	var timer = get_tree().create_timer(1.8)
	await timer.timeout
	Gameloop.player_name = "new_player"
	Gameloop.start_game()
	

func _on_lang_pressed():
	if i == lang.size()-1:
		i = 0
	else:
		i += 1
	TranslationServer.set_locale(lang[i])
	Gameloop.locale_updated.emit(lang[i])


func _on_credits_pressed():
	Gameloop.toggle_credits.emit(true)


# When the user press enter when name input has the focus
func _on_player_name_text_submitted(new_text: String):
	Gameloop.player_name = new_text
	hide()
	Gameloop.start_game()


func _on_player_can_start_playing() -> void:
	animation_player_2.play("menu_goes_away_phase_3")
	# Waiting so the tutorial animation blends better
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	animation_player.stop() # menu_goes_away_phase_2 is still playing in parallel
	neon_flickers.stop() # animation_player.stop doesn't cut the audio
	TutorialManager.tutorial_started.emit()


func _on_locale_updated(locale: String) -> void:
	i = lang.find(locale)
