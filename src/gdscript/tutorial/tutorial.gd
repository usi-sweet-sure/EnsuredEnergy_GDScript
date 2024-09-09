extends CanvasLayer


var i = 0
var j = 0
var tuto_length = 9
var bubble_list
var tutorial_texts = ["TUTORIAL%d", "CLIMATE_TUTORIAL%d"]
var selected_tuto = 0
var tutorial_started = false
var tuto_bb
var tuto_plant
var policies_button



# Called when the node enters the scene tree for the first time.
func _ready():
	bubble_list = $Bubbles.get_children()
	Gameloop.show_tutorial.connect(_on_show_tutorial)
	Gameloop.imported_energy_amount_updated.connect(_on_import_tested)
	selected_tuto = randi_range(0,1)
	print(TranslationServer.get_locale())
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
	Gameloop.locale_updated.connect(_on_locale_updated)
	for build_button in get_tree().get_nodes_in_group("TUTO_BB"):
		tuto_bb = build_button
		build_button.pressed.connect(_on_plant_pressed)
		build_button.plant_tested.connect(_on_plant_tested)
		build_button.plant_canceled.connect(_on_plant_canceled)
	for pp in get_tree().get_nodes_in_group("TUTO_PP"):
		tuto_plant = pp
		
	policies_button = get_node("/root/Main/UI/TopLeftZone/Policies/OpenPoliciesWindowButton")
	policies_button.pressed.connect(_on_policies_pressed)


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
		tutorial_started = false
		
	if i == 4 || i == 6 || i == 7 || i == 10:
		$MarginContainer/NavigationButtons/Next.hide()
	if i == 8:
		tuto_plant.build_info.show()
	if i == 9:
		tuto_plant.build_info.hide()
	

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
		
func _on_plant_pressed():
	if tutorial_started:
		await tuto_bb.bm_anim_player.animation_finished
		$Bubbles/InfoBubble4/BuildBlock.hide()
		
func _on_plant_tested():
	if tutorial_started:
		$MarginContainer/NavigationButtons/Next.show()
		$Bubbles/InfoBubble4/BuildBlock.show()
	
		
func _on_plant_canceled():
	if tutorial_started:
		if i == 6:
			$Bubbles/InfoBubble4/BuildBlock.show()
			$MarginContainer/NavigationButtons/Next.hide()
		if i == 7:
			$MarginContainer/NavigationButtons/Next.show()
			
func _on_policies_pressed():
	hide()
	tutorial_started = false

func _on_skip_pressed():
	hide()


func _on_locale_updated(_locale):
	print(TranslationServer.get_locale())
	$MarginContainer/MarginContainer/Text.text = tr(tutorial_texts[selected_tuto] % i)
