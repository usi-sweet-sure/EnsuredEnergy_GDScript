extends CanvasLayer


var i = 0
var j = 0
var tuto_length = 7
var bubble_list
var tutorial_texts = ["TUTORIAL%d", "CLIMATE_TUTORIAL%d"]
var selected_tuto = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	bubble_list = $Bubbles.get_children()
	Gameloop.show_tutorial.connect(_on_show_tutorial)
	selected_tuto = randi_range(0,1)
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)


func _on_next_button_pressed():
	if i < tuto_length:
		i += 1
		$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
		if i > 2:
			for b in bubble_list:
				b.hide()
			bubble_list[j].show()
			j += 1
	else:
		hide()

func _on_show_tutorial():
	_reset_tutorial()
	show()


func _reset_tutorial():
	i = 0
	j = 0
	
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
	
	for b in bubble_list:
		b.hide()


func _on_skip_pressed():
	hide()
