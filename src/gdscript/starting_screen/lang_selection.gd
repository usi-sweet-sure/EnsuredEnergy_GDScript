extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("buttons_appear")

func _on_lang_button_pressed(locale: String) -> void:
	TranslationServer.set_locale(locale)
	Gameloop.locale_updated.emit(locale)
	animation_player.play("buttons_go_away")

func _on_lang_button_mouse_entered(lang: String) -> void:
	var button = get_node(lang.capitalize() + "Button")
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.15)


func _on_lang_button_mouse_exited(lang: String) -> void:
	var button = get_node(lang.capitalize() + "Button")
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.15)
