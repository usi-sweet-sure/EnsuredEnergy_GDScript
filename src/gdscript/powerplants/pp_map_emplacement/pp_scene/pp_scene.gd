extends Control

class_name PpScene

@onready var floating_message = $InfoFrame/Modifier/FloatingMessageContainer/FloatingMessage


# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)
signal show_info_frame
signal hide_info_frame
signal powerplant_delete_requested(metrics: PowerplantMetrics)
signal powerplant_activated(metrics: PowerplantMetrics)
signal powerplant_deactivated(metrics: PowerplantMetrics)
signal powerplant_upgraded(metrics: PowerplantMetrics)
signal powerplant_downgraded(metrics: PowerplantMetrics)
signal texture_on_changed(image: Image)
signal texture_off_changed(image: Image)

var metrics: PowerplantMetrics

# This is used to revert the changes made to metrics during a shock
var metrics_backup: PowerplantMetrics

func _ready():
	GroupManager.buttons_group_updated.emit()
	GroupManager.switches_group_updated.emit()
	Gameloop.next_turn.connect(_on_next_turn)


func set_metrics(metrics_: PowerplantMetrics):
	self.metrics = metrics_.copy()
	
	change_image(metrics)
	
	# Set effects overlay
	var effects_scene_path = PowerplantsManager.powerplants_effects[metrics_.type]
	if effects_scene_path != "":
		var effects_scene = load(effects_scene_path).instantiate()
		add_child(effects_scene)
		move_child(effects_scene, 3)
		
	metrics_updated.emit(self.metrics)
	

func set_texture_on(texture: Texture):
	texture_on_changed.emit(texture)
	

func set_texture_off(texture: Texture):
	texture_off_changed.emit(texture)


func activate(is_built: bool):
	if metrics.can_activate:
		var was_activated = metrics.active
		
		if not was_activated:
			metrics.active = true
			metrics_updated.emit(metrics)
			powerplant_activated.emit(metrics)
			
			if not is_built:
				Gameloop.available_money_message_requested.emit("-" + str(metrics.production_costs).pad_decimals(2) + "M CHF", false)
	

func deactivate():
	var was_deactivated = not metrics.active
	
	if not was_deactivated:
		metrics.active = false
		metrics_updated.emit(metrics)
		powerplant_deactivated.emit(metrics)
		Gameloop.available_money_message_requested.emit("+" + str(metrics.production_costs).pad_decimals(2) + "M CHF", true)


func _on_close_button_pressed():
	powerplant_delete_requested.emit(metrics)


func _on_pp_focus_exited():
	hide_info_frame.emit()


func _on_pp_toggled(toggled_on: bool):
	PowerplantsManager.pp_scene_toggled.emit(toggled_on, self)
	

func _on_pp_hide_info_frame_requested():
	hide_info_frame.emit()


func _on_pp_show_info_frame_requested():
	show_info_frame.emit()


func _on_switch_toggled(toggled_on: bool):
	if toggled_on:
		activate(false)
	else:
		deactivate()


func _on_next_turn():
	metrics.can_delete = false
	
	var shutting_down_in = metrics.life_span_in_turns - (Gameloop.current_turn - metrics.built_on_turn)
	if shutting_down_in == 0:
		metrics.can_activate = false
		deactivate()
	else:
		metrics_updated.emit(metrics)


func _on_button_plus_pressed():
	var base_metrics = PowerplantsManager.powerplants_metrics[metrics.type]
	var delta_prod_cost = base_metrics.production_costs * metrics.upgrade_factor_for_production_costs
	
	if metrics.current_upgrade < metrics.max_upgrade:
		if MoneyManager.can_spend_the_money(metrics.upgrade_cost + delta_prod_cost):
			metrics.current_upgrade += 1
			
			# Production costs
			metrics.production_costs += delta_prod_cost
			
			# Emissions
			var delta_emissions = base_metrics.emissions * metrics.upgrade_factor_for_emissions
			metrics.emissions += delta_emissions
			
			# Land use
			var delta_land_use = base_metrics.land_use * metrics.upgrade_factor_for_land_use
			metrics.land_use += delta_land_use
			
			# Winter supply
			metrics.availability.y += base_metrics.availability.y * metrics.upgrade_factor_for_winter_supply
			
			# Summer supply
			metrics.availability.x += base_metrics.availability.x * metrics.upgrade_factor_for_summer_supply
			
			# Upgrade cost
			MoneyManager.building_costs += metrics.upgrade_cost
			Gameloop.available_money_message_requested.emit("-" + str(metrics.upgrade_cost + delta_prod_cost).pad_decimals(0) + "M CHF", false)
			
			change_image(metrics)
			
			metrics_updated.emit(metrics)
			powerplant_upgraded.emit(metrics)
		else:
			floating_message.stop()
			floating_message.float_up()


func _on_button_minus_pressed():
	if metrics.current_upgrade > metrics.min_upgrade:
		metrics.current_upgrade -= 1
		
		var base_metrics = PowerplantsManager.powerplants_metrics[metrics.type]
		
		# Production costs
		var delta_prod_cost = base_metrics.production_costs * metrics.upgrade_factor_for_production_costs
		metrics.production_costs -= delta_prod_cost
		
		# Emissions
		var delta_emissions = base_metrics.emissions * metrics.upgrade_factor_for_emissions
		metrics.emissions -= delta_emissions
		
		# Land use
		var delta_land_use = base_metrics.land_use * metrics.upgrade_factor_for_land_use
		metrics.land_use -= delta_land_use
		
		# Winter supply
		metrics.availability.y -= base_metrics.availability.y * metrics.upgrade_factor_for_winter_supply
		
		# Summer supply
		metrics.availability.x -= base_metrics.availability.x * metrics.upgrade_factor_for_summer_supply
		
		# Upgrade cost
		MoneyManager.building_costs -= metrics.upgrade_cost
		Gameloop.available_money_message_requested.emit("+" + str(metrics.upgrade_cost + delta_prod_cost).pad_decimals(0) + "M CHF", true)
		
		change_image(metrics)
		
		metrics_updated.emit(metrics)
		powerplant_downgraded.emit(metrics)


func _on_metrics_updated(_metrics):
	PowerplantsManager.update_buildings_impact()


func is_gas() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.GAS
		
		
func is_nuclear() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.NUCLEAR
		
		
func is_river() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.RIVER


func is_hydro() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.HYDRO


func is_waste() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.WASTE


func is_biomass() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.BIOMASS


func is_solar() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.SOLAR


func is_wind() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.WIND


func is_biogas() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.BIOGAS
		

func is_carbon_sequestration() -> bool:
		return metrics.type == PowerplantsManager.EngineTypeIds.CARBON_SEQUESTRATION


func change_image(metrics_: PowerplantMetrics):
	var image_path_on = PowerplantsManager.get_powerplant_image_path(metrics_.type, metrics_.current_upgrade, true)
	var image_path_off = PowerplantsManager.get_powerplant_image_path(metrics_.type, metrics_.current_upgrade, false)

	texture_on_changed.emit(load(image_path_on))
	texture_off_changed.emit(load(image_path_off))
