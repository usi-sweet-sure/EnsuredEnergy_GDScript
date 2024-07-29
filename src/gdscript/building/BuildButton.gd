extends TextureButton

var building_plant
var turn_left_to_build

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# for each last button in powerplants in buildmenu, connect to pp_pressed
	for pp in $BuildMenu/Container.get_children():
		pp.get_child(-1).pressed.connect(_on_pp_pressed.bind(pp))
		pp.get_child(-1).mouse_entered.connect(_on_pp_mouse_entered.bind(pp))
		pp.get_child(-1).mouse_exited.connect(_on_pp_mouse_exited.bind(pp))
	for pp in $PowerPlants.get_children():
		pp.delete_button.pressed.connect(_on_pp_delete.bind(pp))
	# E. Commented the two following line, there's a bug with delete_button
	#for pp in $PowerPlants.get_children():
		#pp.delete_button.pressed.connect(_on_pp_delete.bind(pp))
		
	Gameloop.next_turn.connect(_check_building_ready)

func _check_building_ready():
	if $BuildingInfo.visible:
		if turn_left_to_build == 1:
			$BuildingInfo.hide()
			_build_plant(building_plant)
		else:
			turn_left_to_build -= 1
			$BuildingInfo/BuildingCancel.hide()
		$BuildingInfo/TurnsLeft.text = str(turn_left_to_build)

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
				
				_build_plant(plant)
			else:
				turn_left_to_build = plant.build_time
				$BuildingInfo/TurnsLeft.text = str(turn_left_to_build)
				$BuildingInfo.show()
				building_plant = plant
				$BuildingInfo/Building/Plate/PlantName.text = plant.plant_name
				$BuildingInfo/Building/Plate/WinterE/WinterE.text = str(plant.availability.y * plant.capacity).pad_decimals(0)
				$BuildingInfo/Building/Plate/SummerE/SummerE.text = str(plant.availability.x * plant.capacity).pad_decimals(0)
	
func _build_plant(plant):
	plant.show()
	plant.add_to_group("PP")
	plant.delete_button.show()
	plant._connect_next_turn_signal()
	
	self_modulate = Color(1,1,1,0)
	disabled = true
	
	var plant_total = 0
	for pp in Gameloop.all_power_plants:
		if pp.plant_name == plant.plant_name:
			plant_total += 1
	var plant_id = plant.plant_name_to_ups_id[plant.plant_name]
	Gameloop.ups_list[plant_id] += plant.cnv_capacity / plant_total
	#Context1.prm_id = plant_id
	#Context1.yr = Gameloop.year_list[Gameloop.current_turn]
	#Context1.tj = plant.cnv_capacity
	#Context1.prm_ups()
	Gameloop._update_buildings_impact()

func _on_close_button_pressed():
	$BuildMenu.hide()
	
func _on_pp_delete(pp):
		pp.hide()
		pp.remove_from_group("PP")
		pp.delete_button.hide()
		self_modulate = Color(1,1,1,1)
		disabled = false
		
		var plant_id = pp.plant_name_to_ups_id[pp.plant_name]
				
		Context1.prm_id = plant_id
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		Context1.tj = -pp.cnv_capacity
		Context1.prm_ups()
		
		Gameloop._update_buildings_impact()

func _on_pp_mouse_entered(pp):
	pp.build_info.show()
func _on_pp_mouse_exited(pp):
	pp.build_info.hide()

func _on_building_cancel_pressed():
	$BuildingInfo.hide()
	self_modulate = Color(1,1,1,1)
	disabled = false


func _on_mouse_entered():
	$AnimationPlayer.play("HammerHit")


func _on_building_info_pressed():
	$BuildingInfo/Building/Plate.visible = !$BuildingInfo/Building/Plate.visible
