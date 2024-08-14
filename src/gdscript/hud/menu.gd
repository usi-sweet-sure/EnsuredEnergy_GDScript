extends CanvasLayer

var lang = ["en", "fr", "de", "it"]
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	TranslationServer.set_locale("en")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	hide()
	

func _on_lang_pressed():
	if i == lang.size()-1:
		i = 0
	else:
		i += 1
	TranslationServer.set_locale(lang[i])
		


func _on_credits_pressed():
	pass # Replace with function body.
