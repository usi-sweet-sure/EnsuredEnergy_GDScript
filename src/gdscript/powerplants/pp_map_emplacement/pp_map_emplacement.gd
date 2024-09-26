extends Node2D

class_name PpMapEmplacement

# Editor will enumerate as 0, 1 and 2.
# MUST BE in same order as PowerplantManager.EngineTypeIds
@export_enum(
	"SOLAR",
	"WIND",
	"GAS",
	"WASTE",
	"BIOMASS",
	"BIOGAS",
	"NUCLEAR",
	"CARBON_SEQUESTRATION",
	"HYDRO",
	"RIVER",
	"NOTHING"
) var build_on_start: int = 10 # 10 = Nothing

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

@export_group("metrics overrides")
@export var life_span_in_turns = 11:
	set(new_value):
		life_span_in_turns = new_value
		override_life_span = true
var override_life_span = false


@onready var bb_normal = $BbNormal
@onready var bb_in_construction = $BbInConstruction

var can_build: Array[PowerplantsManager.EngineTypeIds] = []
# Used to save the name of the pp node when it's built, to know it's name to delete it
# later
var powerplant_node_name: String = ""


func _ready():
	PowerplantsManager.powerplant_build_requested.connect(_on_powerplant_build_requested)
	
	# Will be disconnected after the first signal emition
	if build_on_start != 10: # 10 = Nothing
		PowerplantsManager.powerplants_metrics_updated.connect(_build_on_start)
	
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
		
		
func _on_bb_normal_toggled(toggled_on: bool):
	# The build menu listens to this and emits back a build request with necessary,
	# data, managed in "_on_powerplant_build_requested" below
	PowerplantsManager.build_button_normal_toggled.emit(toggled_on, self, can_build)
	
	
func _on_bb_in_construction_toggled(toggled_on):
	PowerplantsManager.build_button_in_construction_toggled.emit(toggled_on, self)
	
	
func _on_powerplant_build_requested(map_emplacement: Node, metrics: PowerplantMetrics):
	if map_emplacement == self:
		bb_normal.hide()
		
		var new_metrics = metrics.copy()
		override_metrics(new_metrics)
		
		if new_metrics.build_time_in_turns > 0:
			bb_in_construction.set_metrics(new_metrics)
			bb_in_construction.show()
		else:
			var pp_scene = PowerplantsManager.powerplant_scene.instantiate()
			add_child(pp_scene)
			powerplant_node_name = pp_scene.name
			pp_scene.set_metrics(new_metrics)
			pp_scene.powerplant_delete_requested.connect(_on_powerplant_delete_requested)
			pp_scene.activate()
			

func _on_powerplant_delete_requested():
	var node = get_node(powerplant_node_name)
	remove_child(node)
	node.queue_free()
	bb_normal.show()


func _on_powerplant_cancel_construction_requested():
	bb_in_construction.hide()
	bb_normal.show()
	

func _build_on_start(metrics: Array[PowerplantMetrics]):
	PowerplantsManager.powerplants_metrics_updated.disconnect(_build_on_start)
	var new_metrics = metrics[build_on_start].copy()
	new_metrics.build_time_in_turns = 0
	new_metrics.can_delete = false
	new_metrics.building_costs = 0
	_on_powerplant_build_requested(self, new_metrics)
	

# Applies the changes made in the editor
func override_metrics(metrics: PowerplantMetrics):
	metrics.built_on_turn = Gameloop.current_turn
	
	if override_life_span:
		metrics.life_span_in_turns = life_span_in_turns


func _on_powerplant_construction_ended(metrics: PowerplantMetrics):
	metrics.build_time_in_turns = 0
	metrics.building_costs = 0 # already paid when the construction started
	PowerplantsManager.powerplant_build_requested.emit(self, metrics)
