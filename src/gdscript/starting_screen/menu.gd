extends CanvasLayer

var lang = ["de", "fr", "it", "en"]
var i = 0
@onready var hud: CanvasLayer = $CanvasLayer
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var animation_player: AnimationPlayer = $AnimationPlayer


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


func _on_play_pressed():
	animation_player.play("menu_goes_away_phase_1")
	await  animation_player.animation_finished
	animation_player.play("menu_goes_away_phase_2")
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
	Gameloop.toggle_credits.emit()


# When the user press enter when name input has the focus
func _on_player_name_text_submitted(new_text: String):
	Gameloop.player_name = new_text
	hide()
	Gameloop.start_game()


func _on_player_can_start_playing() -> void:
	if animation_player.is_playing() and animation_player.current_animation == "menu_goes_away_phase_1":
		await animation_player.animation_finished
		animation_player.play("menu_goes_away_phase_3")
		# Waiting so the tutorial animation blends better
		var timer = get_tree().create_timer(0.5)
		await timer.timeout
		TutorialManager.tutorial_started.emit()
	else:
		animation_player.play("menu_goes_away_phase_3")
		# Waiting so the tutorial animation blends better
		var timer = get_tree().create_timer(0.5)
		await timer.timeout
		TutorialManager.tutorial_started.emit()
