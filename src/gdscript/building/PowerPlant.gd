extends Node2D


@export var is_in_menu := false

@export var availability = Vector2(0.5, 0.5)
@export var capacity: float = 10.0
@export var plant_name: String = "gas"
@export var life_span: int = 11
@export var max_upgrade: int = 3
@export var build_time: int = 0
@export var build_cost: int = 100
@export var production_cost: float = 0.0
@export var pollution: float = 0.0
@export var land_use: float = 1.0
@export var upgrade_cost: int = 25


var is_alive: bool = true
var upgrade: int = 0
@export var mult_factor: float = 0.025
var cnv_capacity: float
var base_capacity
var base_pollution
var base_land_use
var base_production_cost
var upgrade_per_turn = 0

@onready var delete_button = $Delete
@onready var build_info = $BuildInfo
@onready var multiplier = $BuildInfo/EnergyContainer/Multiplier
@onready var summer_energy = $BuildInfo/EnergyContainer/Summer/BuildMenuNumCounter3/SummerE
@onready var winter_energy = $BuildInfo/EnergyContainer/Winter/BuildMenuNumCounter3/WinterE
@onready var metrics_container = $BuildInfo/ColorRect/ContainerN
var metrics_container_original_position: Vector2
@onready var modifiers_preview_elements = {
	"winter_sticker": $BuildInfo/WinterMultSticker,
	"summer_sticker": $BuildInfo/SummerMultSticker,
	"red_cost_sticker": $BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker,
	"green_cost_sticker": $BuildInfo/EnergyContainer/Multiplier/PriceMultGreenSticker,
	"prod_upgrade": $BuildInfo/ColorRect/ContainerN/Prod/Upgrade,
	"prod_downgrade": $BuildInfo/ColorRect/ContainerN/Prod/Downgrade,
	"poll_upgrade": $BuildInfo/ColorRect/ContainerN/Poll/Upgrade,
	"poll_downgrade": $BuildInfo/ColorRect/ContainerN/Poll/Downgrade,
	"land_upgrade": $BuildInfo/ColorRect/ContainerN/Land/Upgrade,
	"land_downgrade": $BuildInfo/ColorRect/ContainerN/Land/Downgrade,
}

var plant_name_to_model = {
	"GAS": "187",
	"NUCLEAR": "152",
	"RIVER": "160",
	"HYDRO": "161",
	"WASTE": "190",
	"BIOMASS": "193",
	"SOLAR": "168",
	"WIND": "169",
	"CARBON": "774",
	"BIOGAS" : "173"
}

var plant_name_to_ups_id = {
	"GAS": "186",
	"NUCLEAR": "151",
	"RIVER": "162",
	"HYDRO": "163",
	"WASTE": "189",
	"BIOMASS": "192",
	"SOLAR": "170",
	"WIND": "171",
	"CARBON": "774",
	"BIOGAS": "175"
}

var plant_name_to_metric_id = {
	"GAS_EMI": "254",
	"GAS_LAND": "284",
	"GAS_COST": "324",
	"NUCLEAR_EMI": "252",
	"NUCLEAR_LAND": "282",
	"NUCLEAR_COST": "322",
	"HYDRO_EMI": "458",
	"HYDRO_LAND": "459",
	"HYDRO_COST": "460",
	"RIVER_EMI": "253",
	"RIVER_LAND": "283",
	"RIVER_COST": "323",
	"WASTE_EMI": "255",
	"WASTE_LAND": "285",
	"WASTE_COST": "325",
	"BIOMASS_EMI": "256",
	"BIOMASS_LAND": "286",
	"BIOMASS_COST": "326",
	"SOLAR_EMI": "258",
	"SOLAR_LAND": "288",
	"SOLAR_COST": "328",
	"WIND_EMI": "259",
	"WIND_LAND": "289",
	"WIND_COST": "329",
	"GAS_AVAIL": "334",
	"NUCLEAR_AVAIL" : "332",
	"RIVER_AVAIL": "333",
	"HYDRO_AVAIL": "461",
	"WASTE_AVAIL": "335",
	"BIOMASS_AVAIL": "336",
	"BIOGAS_AVAIL": "337",
	"SOLAR_AVAIL": "338",
	"WIND_AVAIL": "339",
	"BIOGAS_EMI": "257",
	"BIOGAS_LAND": "287",
	"BIOGAS_COST": "327",
	"CARBON_COST": "526",
	"CARBON_EMI": "525",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	#Context1.http1.request_completed.connect(_on_request_completed)
	Gameloop.next_turn.connect(_on_next_turn)
	Gameloop.locale_updated.connect(_on_locale_updated)
	Gameloop.available_money_amount_updated.connect(_on_available_money_updated)
	
	_update_info()
	metrics_container_original_position = metrics_container.position
	

func _update_info():
	# updates the energy produced by a plant in summer and winter
	$PreviewInfo/EnergyS.text = str(availability.x * capacity).pad_decimals(0)
	$PreviewInfo/EnergyW.text = str(availability.y * capacity).pad_decimals(0)
	summer_energy.text = str(availability.x * capacity).pad_decimals(0)
	winter_energy.text = str(availability.y * capacity).pad_decimals(0)
	
	# updates metrics
	$BuildInfo/ColorRect/ContainerN/Prod.text = "-" + str(production_cost).pad_decimals(0) + "M CHF"
	$BuildInfo/ColorRect/ContainerN/Poll.text = str(pollution).pad_decimals(2) + "M CO2"
	$BuildInfo/ColorRect/ContainerN/Land.text = str(land_use).pad_decimals(2) + " ha"
	
	$BuildInfo/ColorRect/LifeSpan.text = str(life_span - Gameloop.current_turn + 1)
	
	if life_span < Gameloop.current_turn:
		$BuildInfo/ColorRect/LifeSpan.hide()
		$LifeSpanWarning.hide()
	else:
		if Gameloop.current_turn == life_span:
			$LifeSpanWarning.show()
			
	$BuildInfo/ColorRect/LifeSpan.text = tr("SHUT_DOWN").format({nbr = str(life_span - Gameloop.current_turn + 1)}) 
	# Below we add a decimal to round values so it looks like a money value
	#build_cost = 100.69
	if floor(build_cost) == build_cost:
		# 100 becomes 100.0
		$PreviewInfo/Price.text = str(build_cost + production_cost).pad_decimals(1)
	else:
		# 100.xx stays 100.xx
		$PreviewInfo/Price.text = str(build_cost + production_cost).pad_decimals(2)
		
	if build_time > 0:
		$PreviewInfo/Time.show()
		$PreviewInfo/TimeIcon.show()
		$PreviewInfo/Time.text = str(build_time)
	else:
		$PreviewInfo/Time.hide()
		$PreviewInfo/TimeIcon.hide()
	
	# multiplier upgrade infos
	if max_upgrade > 1:
		if not is_in_menu:
			$BuildInfo/EnergyContainer/Multiplier.show()
			$BuildInfo/EnergyContainer/Multiplier/Inc.show()
		$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)
	$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)
	
	# updates texts
	$NameRect/Name.text = tr(plant_name)
	$BuildInfo/Name.text = tr(plant_name)

# add the model numbers to the plant
func _on_request_finished(_result, _response_code, _headers, _body):
	# E. Had to add this after geothermal removal, for the game to not crash
	if plant_name != "CARBON":
		var model_key = plant_name_to_model[plant_name]
		var plant_id = plant_name_to_ups_id[plant_name]
		var poll_key = plant_name_to_metric_id[plant_name + "_EMI"]
		var land_key = plant_name_to_metric_id[plant_name + "_LAND"]
		var cost_key = plant_name_to_metric_id[plant_name + "_COST"]
		var avail_key = plant_name_to_metric_id[plant_name + "_AVAIL"]
		
		if Context1.ctx1 != null:
			for i in Context1.ctx1:
				match i["prm_id"]:
					model_key:
						capacity = float(i["tj"])
					plant_id:
						cnv_capacity = float(i["tj"])
					poll_key:
						pollution = float(i["tj"])
					land_key:
						land_use = float(i["tj"])
					cost_key:
						production_cost = float(i["tj"]) / 10
					avail_key:
						availability.x = float(i["tj"]) / capacity
						availability.y = 1 - availability.x
		
		if is_nuclear():
			capacity = capacity / 100.0 / 3.0 # there's 3 nuclear plants
			pollution /= 3
			land_use /= 3
			production_cost = production_cost / 10 / 3
		elif is_hydro() || is_river():
			capacity = capacity / 100.0 / 2.0
			pollution /= 4 # needs to divide by the number of water plants
			land_use /= 4
			production_cost = production_cost / 10 / 4
		else:
			capacity /= 100.0
		
		base_capacity = capacity
		base_pollution = pollution
		base_land_use = land_use
		base_production_cost = production_cost
		
	else:
		var plant_id = plant_name_to_ups_id[plant_name]
		var poll_key = plant_name_to_metric_id[plant_name + "_EMI"]
		var cost_key = plant_name_to_metric_id[plant_name + "_COST"]
		
		if Context1.ctx1 != null:
			for i in Context1.ctx1:
				match i["prm_id"]:
					plant_id:
						cnv_capacity = float(i["tj"])
					poll_key:
						pollution = float(i["tj"])
					cost_key:
						production_cost = float(i["tj"]) / 10
						
		base_pollution = pollution
		base_production_cost = production_cost
		
	_update_info()
	Context1.http1.request_completed.disconnect(_on_request_finished)
	Gameloop._update_buildings_impact()


#func _on_request_completed(_result, _response_code, _headers, _body):
	#$BuildInfo/EnergyContainer/Multiplier/Inc.disabled = false
	#$BuildInfo/EnergyContainer/Multiplier/Dec.disabled = false


func _on_info_button_pressed():
	$BuildInfo.visible = !$BuildInfo.visible


func _on_mult_inc_pressed():
	if upgrade < max_upgrade:
		if Gameloop.can_spend_the_money(upgrade_cost):
			Gameloop.building_costs += upgrade_cost
			$BuildInfo/EnergyContainer/Multiplier/Dec.show()
			$Money.text = "-" + str(upgrade_cost) + "$"
			$AP.stop()
			$AP.play("Money-")
			upgrade += 1
			
			if plant_name != "CARBON":
				var plant_id = plant_name_to_ups_id[plant_name]
				var value = (cnv_capacity * mult_factor * upgrade) #S. !! Check rounding of the value in model
				capacity = base_capacity + (base_capacity * mult_factor * upgrade)
				pollution = base_pollution + (base_pollution * mult_factor * upgrade)
				land_use = base_land_use + (base_land_use * mult_factor * upgrade)
				production_cost = base_production_cost + (base_production_cost * mult_factor * upgrade)
				
				Gameloop.ups_list[plant_id] += value
				
			else:
				var plant_id = plant_name_to_ups_id[plant_name]
				upgrade_per_turn += 1
				var value = 0.5 * upgrade_per_turn
				Context1.prm_id = plant_id
				Context1.yr = Gameloop.year_list[Gameloop.current_turn]
				Context1.tj = value
				Context1.prm_ups()
				$BuildInfo/EnergyContainer/Multiplier/Inc.disabled = true
				
				await Context1.http1.request_completed
				$BuildInfo/EnergyContainer/Multiplier/Inc.disabled = false
				var poll_key = plant_name_to_metric_id[plant_name + "_EMI"]
				var cost_key = plant_name_to_metric_id[plant_name + "_COST"]
		
				if Context1.ctx1 != null:
					for i in Context1.ctx1:
						match i["prm_id"]:
							poll_key:
								pollution = float(i["tj"])
							cost_key:
								production_cost = float(i["tj"]) / 10
				
			
			_update_info()
			Gameloop._update_buildings_impact()
			
			if upgrade == max_upgrade:
				$BuildInfo/EnergyContainer/Multiplier/Inc.hide()
			#$BuildInfo/EnergyContainer/Multiplier/Inc.disabled = true
			#$BuildInfo/EnergyContainer/Multiplier/Dec.disabled = true
		else:
			# E. Notify user they don't have enough money
			pass

func _on_mult_dec_pressed():
	if upgrade > 0:
		Gameloop.building_costs -= upgrade_cost
		$BuildInfo/EnergyContainer/Multiplier/Inc.show()
		
		$Money.text = "+" + str(upgrade_cost) + "$"
		$AP.stop()
		$AP.play("Money+")
		
		upgrade -= 1
		if plant_name != "CARBON":
			var plant_id = plant_name_to_ups_id[plant_name]
			var value = (cnv_capacity * mult_factor * upgrade)
			capacity = base_capacity + (base_capacity * mult_factor * upgrade)
			pollution = base_pollution + (base_pollution * mult_factor * upgrade)
			land_use = base_land_use + (base_land_use * mult_factor * upgrade)
			production_cost = base_production_cost + (base_production_cost * mult_factor * upgrade)
			
			Gameloop.ups_list[plant_id] += value
			#Context1.prm_id = plant_id
			#Context1.yr = Gameloop.year_list[Gameloop.current_turn]
			#Context1.tj = value
			#Context1.prm_ups()
		else:
			var plant_id = plant_name_to_ups_id[plant_name]
			upgrade_per_turn -= 1
			var value = 0.5 * upgrade_per_turn
			Context1.prm_id = plant_id
			Context1.yr = Gameloop.year_list[Gameloop.current_turn]
			Context1.tj = value
			Context1.prm_ups()
			$BuildInfo/EnergyContainer/Multiplier/Dec.disabled = true
			
			await Context1.http1.request_completed
			$BuildInfo/EnergyContainer/Multiplier/Dec.disabled = false
			var poll_key = plant_name_to_metric_id[plant_name + "_EMI"]
			var cost_key = plant_name_to_metric_id[plant_name + "_COST"]
	
			if Context1.ctx1 != null:
				for i in Context1.ctx1:
					match i["prm_id"]:
						poll_key:
							pollution = float(i["tj"])
						cost_key:
							production_cost = float(i["tj"]) / 10
		
		_update_info()
		Gameloop._update_buildings_impact()
		
		if upgrade == 0:
			$BuildInfo/EnergyContainer/Multiplier/Dec.hide()
		# E. Is this intended ? Commenting it in the meantime
		#$BuildInfo/EnergyContainer/Multiplier/Inc.disabled = true
		#$BuildInfo/EnergyContainer/Multiplier/Dec.disabled = true
		
func _connect_next_turn_signal():
	if !Gameloop.next_turn.is_connected(_hide_delete_on_next_turn):
		Gameloop.next_turn.connect(_hide_delete_on_next_turn)


func _hide_delete_on_next_turn():
	delete_button.hide()


func _check_life_span():
	# A life span of 3 means the power plants lives 3 full turns, then shuts down on the fourth.
	# The game start counting at 1, not zero.
	if life_span < Gameloop.current_turn:
		_disable()
		
		
# Make the pp unusable
func _disable():
	var switch: CheckButton = $BuildInfo/Switch
	_on_switch_toggled(false)
	switch.disabled = true
	
	
# Make the pp usable
# Do not activate it, it costs money and the player should manage this
func _enable():
	$BuildInfo/Switch.disabled = false
	_on_switch_toggled(true)
	

func _on_switch_toggled(toggled_on):
	is_alive = toggled_on
	
	if toggled_on:
		modulate = Color(1, 1, 1, 1)
		$BuildInfo/Switch/LEDOn.show()
		#play animation
		_update_info()
		#add_to_group("PP")
		
		var plant_id = plant_name_to_ups_id[plant_name]
		
		var effect_sprites = get_node("Sprite").get_children()
		
		for effect in effect_sprites:
			effect.show()
				
		Context1.prm_id = plant_id
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		var plant_total = 0
		var off_plant_total = 0
		for pp in Gameloop.all_power_plants:
			if pp.plant_name == plant_name:
				plant_total += 1
				if !pp.is_alive:
					off_plant_total += 1
		
		Gameloop.ups_list[plant_id] += -(cnv_capacity / plant_total) * off_plant_total
		#Context1.tj = -(cnv_capacity / plant_total) * off_plant_total
		#Context1.prm_ups()
	else:
		modulate = Color(0.8, 0.8, 0.8, 1)
		$BuildInfo/Switch/LEDOn.hide()
		#stop animation
		summer_energy.text = "0"
		winter_energy.text = "0"
		#remove_from_group("PP")
		
		var effect_sprites = get_node("Sprite").get_children()
		
		for effect in effect_sprites:
			effect.hide()
		
		
		var plant_id = plant_name_to_ups_id[plant_name]
				
		var plant_total = 0
		var off_plant_total = 0
		for pp in Gameloop.all_power_plants:
			if pp.plant_name == plant_name:
				plant_total += 1
				if !pp.is_alive:
					off_plant_total += 1
		# TODO fix problem of building new powerplant then switching off same turn
		Gameloop.ups_list[plant_id] += -(cnv_capacity / plant_total) * off_plant_total
		#Context1.prm_id = plant_id
		#Context1.tj = -(cnv_capacity / plant_total) * off_plant_total
		#Context1.prm_ups()
		
	Gameloop._update_buildings_impact()
	

func _on_next_turn():
	_check_life_span()
	_update_info()
	upgrade_per_turn = 0
	

func _on_available_money_updated(available_money):
	if is_in_menu:
		$NoMoneyOverlay.visible = not Gameloop.can_spend_the_money(build_cost + production_cost)
	
func _on_upgrade_button_mouse_entered():
	if plant_name != "CARBON":
		var tween = get_tree().create_tween()
		tween.tween_property(metrics_container, "position", 
				Vector2(metrics_container_original_position.x - 62,
				metrics_container_original_position.y), 0.1)
		
		for element in modifiers_preview_elements:
			var node = modifiers_preview_elements[element]
			node.show()
			   
			match element:
				"winter_sticker":
					node.get_children()[0].text = "+ " + str(base_capacity * mult_factor * availability.y).pad_decimals(2)
				"summer_sticker":
					node.get_children()[0].text = "+ " + str(base_capacity * mult_factor * availability.x).pad_decimals(2)
				"red_cost_sticker":
					node.get_children()[0].text = "- " + str(upgrade_cost) + " CHF"
				"green_cost_sticker":
					node.hide()
				"prod_downgrade":
					node.text = "+ " + str(production_cost * mult_factor).pad_decimals(2)
				"prod_upgrade":
					node.hide()
				"poll_upgrade":
					node.hide()
				"poll_downgrade":
					if(str(pollution * mult_factor).pad_decimals(2) != "0.00"):
						node.text = "+ " + str(pollution * mult_factor).pad_decimals(2)
					else:
						node.hide()
				"land_upgrade":
					node.hide()
				"land_downgrade":
					if(str(land_use * mult_factor).pad_decimals(2) != "0.00"):
						node.text = "+ " + str(land_use * mult_factor).pad_decimals(2)
					else:
						node.hide()


func _on_downgrade_button_mouse_entered():
	if plant_name != "CARBON":
		var tween = get_tree().create_tween()
		tween.tween_property(metrics_container, "position", 
				Vector2(metrics_container_original_position.x - 62,
				metrics_container_original_position.y), 0.1)
				
		for element in modifiers_preview_elements:
			var node = modifiers_preview_elements[element]
			node.show()
			
			match element:
				"winter_sticker":
					node.get_children()[0].text = "- " + str(base_capacity * mult_factor * availability.y).pad_decimals(2)
				"summer_sticker":
					node.get_children()[0].text = "- " + str(base_capacity * mult_factor  * availability.x).pad_decimals(2)
				"red_cost_sticker":
					node.hide()
				"green_cost_sticker":
					node.get_children()[0].text = "+ " + str(upgrade_cost) + " CHF"
				"prod_downgrade":
					node.hide()
				"prod_upgrade":
					node.text = "- " + str(production_cost * mult_factor).pad_decimals(2)
				"poll_upgrade":
					if(str(pollution * mult_factor).pad_decimals(2) != "0.00"):
						node.text = "- " + str(pollution * mult_factor).pad_decimals(2)
					else:
						node.hide()
				"poll_downgrade":
					node.hide()
				"land_upgrade":
					if(str(land_use * mult_factor).pad_decimals(2) != "0.00"):
						node.text = "- " + str(land_use * mult_factor).pad_decimals(2)
					else:
						node.hide()
				"land_downgrade":
					node.hide()


func _on_upgrade_button_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(metrics_container, "position", 
			metrics_container_original_position, 0.1)
			
	for element in modifiers_preview_elements:
		modifiers_preview_elements[element].hide()


func _on_downgrade_button_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(metrics_container, "position", 
			metrics_container_original_position, 0.1)
			
	for element in modifiers_preview_elements:
		modifiers_preview_elements[element].hide()


func is_gas() -> bool:
		return plant_name == "GAS"
		
		
func is_nuclear() -> bool:
		return plant_name == "NUCLEAR"
		
		
func is_river() -> bool:
		return plant_name == "RIVER"


func is_hydro() -> bool:
		return plant_name == "HYDRO"


func is_waste() -> bool:
		return plant_name == "WASTE"


func is_biomass() -> bool:
		return plant_name == "BIOMASS"


func is_solar() -> bool:
		return plant_name == "SOLAR"


func is_wind() -> bool:
		return plant_name == "WIND"


func is_geothermal() -> bool:
		return plant_name == "GEOTHERMAL"


func is_biogas() -> bool:
		return plant_name == "BIOGAS"


# Used for the end of the game
func _disable_with_no_effect():
	$BuildInfo/Switch.disabled = true
	$BuildInfo/Switch/LEDOn.hide()
	is_alive = false


func _on_locale_updated(_locale):
	$NameRect/Name.text = tr(plant_name)
	$BuildInfo/Name.text = tr(plant_name)
	
	if life_span >= Gameloop.current_turn:
		$BuildInfo/ColorRect/LifeSpan.text = tr("SHUT_DOWN").format({nbr = str(life_span - Gameloop.current_turn + 1)}) 


func _on_multinc_mouse_entered():
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.text = "-" + str(upgrade_cost)
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.show()
	$BuildInfo/WinterMultSticker.show()
	$BuildInfo/SummerMultSticker.show()
	

func _on_multinc_mouse_exited():
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.hide()
	$BuildInfo/WinterMultSticker.hide()
	$BuildInfo/SummerMultSticker.hide()

func _on_multdec_mouse_entered():
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.text = "+" + str(upgrade_cost)
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.show()
	$BuildInfo/WinterMultSticker.show()
	$BuildInfo/SummerMultSticker.show()
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker/GreenPostit.show()

func _on_multdec_mouse_exited():
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker.hide()
	$BuildInfo/WinterMultSticker.hide()
	$BuildInfo/SummerMultSticker.hide()
	$BuildInfo/EnergyContainer/Multiplier/PriceMultRedSticker/GreenPostit.hide()
	
func _unhandled_input(event):
	# Mouse drag moves the camera
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			$BuildInfo.hide()
