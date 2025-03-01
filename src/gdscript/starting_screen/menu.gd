extends CanvasLayer

var lang = ["de", "fr", "it", "en"]
var i = 0
@onready var hud: CanvasLayer = $CanvasLayer
@onready var parallax_background: ParallaxBackground = $ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	if SurveyManager.locale == "":
		TranslationServer.set_locale("de")
		Gameloop.locale_updated.emit("de")
	else:
		TranslationServer.set_locale(SurveyManager.locale)
		Gameloop.locale_updated.emit(SurveyManager.locale)


func _on_play_pressed():
	Gameloop.player_name = "new_player"
	hud.hide()
	parallax_background.hide()
	hide()
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
