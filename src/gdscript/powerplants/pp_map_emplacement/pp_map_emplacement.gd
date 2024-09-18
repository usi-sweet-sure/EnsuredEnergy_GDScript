extends Node2D

@export_group("Can Build")
@export var solar := true
@export var wind := true
@export var gas := true
@export var waste := true
@export var biomass := true
@export var biogas := true
@export var nuclear := false
@export var carbon_sequestration := false
@export var hydro := false
@export var river := false

var can_build: Array[PowerplantsManager.EngineTypeIds] = []

func _ready():
	if solar:
		can_build.push_back(PowerplantsManager.EngineTypeIds.SOLAR)
	if wind:
		can_build.push_back(PowerplantsManager.EngineTypeIds.WIND)
	if gas:
		can_build.push_back(PowerplantsManager.EngineTypeIds.GAS)
	if waste:
		can_build.push_back(PowerplantsManager.EngineTypeIds.WASTE)
	if biomass:
		can_build.push_back(PowerplantsManager.EngineTypeIds.BIOMASS)
	if biogas:
		can_build.push_back(PowerplantsManager.EngineTypeIds.BIOGAS)
	if nuclear:
		can_build.push_back(PowerplantsManager.EngineTypeIds.NUCLEAR)
	if carbon_sequestration:
		can_build.push_back(PowerplantsManager.EngineTypeIds.CARBON_SEQUESTRATION)
	if hydro:
		can_build.push_back(PowerplantsManager.EngineTypeIds.HYDRO)
	if river:
		can_build.push_back(PowerplantsManager.EngineTypeIds.RIVER)
		
		
func _on_bb_normal_pressed():
	PowerplantsManager.toggle_menu.emit(can_build)
	PowerplantsManager.powerplant_build_requested.connect(_on_powerplant_build_requested)
	print("listening")
	
func _on_powerplant_build_requested(metrics: PowerplantMetrics):
	print("build")
