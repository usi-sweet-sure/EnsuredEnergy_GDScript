extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# for each last button in powerplants in buildmenu, connect to pp_pressed
	for pp in $BuildMenu/Container.get_children():
		pp.get_child(-1).pressed.connect(_on_pp_pressed.bind(pp))
		pp.get_child(-1).mouse_entered.connect(_on_pp_mouse_entered.bind(pp))
		pp.get_child(-1).mouse_exited.connect(_on_pp_mouse_exited.bind(pp))
	for pp in $PowerPlants.get_children():
		pp.delete_button.pressed.connect(_on_pp_delete.bind(pp))


# when pressing on a buildbutton
func _on_pressed():
	$BuildMenu.show()
	$BuildMenu/AnimationPlayer.play("SlideUp")
	
# when pressing on a powerplant in buildmenu
func _on_pp_pressed(pp):
	$BuildMenu.hide()
	for plant in $PowerPlants.get_children():
		if pp.name == plant.name:
			if pp.build_time < 1:
				plant.show()
				plant.delete_button.show()
				self_modulate = Color(1,1,1,0)
				disabled = true
			else:
				$BuildingInfo.show()
	


func _on_close_button_pressed():
	$BuildMenu.hide()
	
func _on_pp_delete(pp):
	for plant in $PowerPlants.get_children():
		if pp.name == plant.name:
			plant.hide()
			plant.delete_button.hide()
			self_modulate = Color(1,1,1,1)
			disabled = false

func _on_pp_mouse_entered(pp):
	pp.build_info.show()
func _on_pp_mouse_exited(pp):
	pp.build_info.hide()

func _on_building_cancel_pressed():
	$BuildingInfo.hide()
	self_modulate = Color(1,1,1,1)
	disabled = false
