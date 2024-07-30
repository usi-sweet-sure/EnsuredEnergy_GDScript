extends TextureButton

var lang = ["en", "fr", "de", "it"]

func _on_pressed():
	var current_locale_index = lang.find(TranslationServer.get_locale())

	if current_locale_index != -1:
		var new_locale_index = current_locale_index + 1
		
		if current_locale_index == lang.size() - 1:
			new_locale_index = 0
		
		var new_locale = lang[new_locale_index]
		TranslationServer.set_locale(new_locale)
		
		# We need to send this signal because some translations have dynamic
		# variables, using tr("text {varibale}").format({variable: value}).
		# Those cases don't update automatically when changing the language at runtime,
		# and only update when the statement with .format is called again.
		# So we listen to this signal and call those statements again
		Gameloop.locale_updated.emit(new_locale)
