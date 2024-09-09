extends CanvasLayer


var i = 0
var j = 0
var tuto_length = 8
var bubble_list
var tutorial_texts = ["TUTORIAL%d", "CLIMATE_TUTORIAL%d"]
var selected_tuto = 0
var tutorial_started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	bubble_list = $Bubbles.get_children()
	Gameloop.show_tutorial.connect(_on_show_tutorial)
	Gameloop.imported_energy_amount_updated.connect(_on_import_tested)
	selected_tuto = randi_range(0,1)
	print(TranslationServer.get_locale())
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
	Gameloop.locale_updated.connect(_on_locale_updated)


func _on_next_button_pressed():
	$MarginContainer/NavigationButtons/Skip.hide()
	tutorial_started = true
	if i < tuto_length:
		i += 1
		$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
		if i > 1:
			$Bubbles/MouseBlock.hide()
			for b in bubble_list:
				b.hide()
			bubble_list[j].show()
			j += 1
	else:
		hide()
		
	if i == 4:
		$MarginContainer/NavigationButtons/Next.hide()

func _on_show_tutorial():
	_reset_tutorial()
	show()


func _reset_tutorial():
	i = 0
	j = 0
	
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
	
	for b in bubble_list:
		b.hide()
		
# E. Ideally the signal should be on drag ended and show the next bubble (i++ and j++)
func _on_import_tested(new_val):
	if tutorial_started:
		$MarginContainer/NavigationButtons/Next.show()
		


func _on_skip_pressed():
	hide()


func _on_locale_updated(_locale):
	print(TranslationServer.get_locale())
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
