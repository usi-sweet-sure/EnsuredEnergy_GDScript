extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_lang_button_pressed(locale: String) -> void:
	TranslationServer.set_locale(locale)
	Gameloop.locale_updated.emit(locale)
	animation_player.play("language_selection_goes_away")
