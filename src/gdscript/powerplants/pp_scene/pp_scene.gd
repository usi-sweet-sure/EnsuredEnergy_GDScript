extends Control

class_name PpScene

@onready var floating_message = $InfoFrame/Modifier/FloatingMessageContainer/FloatingMessage


# Used to update children
signal metrics_updated(metrics: PowerplantMetrics)
signal show_info_frame
signal hide_info_frame
signal powerplant_delete_requested(metrics: PowerplantMetrics)
signal texture_on_changed(image: Image)
signal texture_off_changed(image: Image)

var metrics: PowerplantMetrics

func _ready():
	GroupManager.buttons_group_updated.emit()
	GroupManager.switches_group_updated.emit()
	Gameloop.next_turn.connect(_on_next_turn)


func set_metrics(metrics: PowerplantMetrics):
	self.metrics = metrics.copy()
	texture_on_changed.emit(PowerplantsManager.powerplants_textures_on[metrics.type])
	texture_off_changed.emit(PowerplantsManager.powerplants_textures_off[metrics.type])
	metrics_updated.emit(self.metrics)


func activate():
	if metrics.can_activate:
		metrics.active = true
		metrics_updated.emit(metrics)
	

func deactivate():
	metrics.active = false
	metrics_updated.emit(metrics)


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
	metrics.active = toggled_on
	metrics_updated.emit(metrics)


func _on_next_turn():
	metrics.can_delete = false
	
	var shutting_down_in = metrics.life_span_in_turns - (Gameloop.current_turn - metrics.built_on_turn)
	if shutting_down_in == 0:
		metrics.active = false
		metrics.can_activate = false
	
	metrics_updated.emit(metrics)


func _on_button_plus_pressed():
	var base_metrics = PowerplantsManager.powerplants_metrics[metrics.type]
	var delta_prod_cost = base_metrics.production_costs * metrics.upgrade_factor_for_production_costs
	
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
		var delta_winter_supply = base_metrics.availability.y * base_metrics.capacity * metrics.upgrade_factor_for_winter_supply
		metrics.availability.y += base_metrics.availability.y * metrics.upgrade_factor_for_winter_supply
		
		# Summer supply
		var delta_summer_supply = base_metrics.availability.x * base_metrics.capacity * metrics.upgrade_factor_for_summer_supply
		metrics.availability.x += base_metrics.availability.x * metrics.upgrade_factor_for_summer_supply
		
		# Upgrade cost
		MoneyManager.building_costs += metrics.upgrade_cost
		
		metrics_updated.emit(metrics)
	else:
		floating_message.stop()
		floating_message.float_up()


func _on_button_minus_pressed():
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
	var delta_winter_supply = base_metrics.availability.y * base_metrics.capacity * metrics.upgrade_factor_for_winter_supply
	metrics.availability.y -= base_metrics.availability.y * metrics.upgrade_factor_for_winter_supply
	
	# Summer supply
	var delta_summer_supply = base_metrics.availability.x * base_metrics.capacity * metrics.upgrade_factor_for_summer_supply
	metrics.availability.x -= base_metrics.availability.x * metrics.upgrade_factor_for_summer_supply
	
	# Upgrade cost
	MoneyManager.building_costs -= metrics.upgrade_cost
	
	metrics_updated.emit(metrics)


func _on_metrics_updated(metrics):
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
