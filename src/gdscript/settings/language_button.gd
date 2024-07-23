extends TextureButton

var lang = ["en", "fr", "de", "it"]

func _on_pressed():
	var current_locale_index = lang.find(TranslationServer.get_locale())

	if current_locale_index != -1:
		var new_locale_index = current_locale_index + 1
		
		if current_locale_index == lang.size() - 1:
			new_locale_index = 0
		
		TranslationServer.set_locale(lang[new_locale_index])
