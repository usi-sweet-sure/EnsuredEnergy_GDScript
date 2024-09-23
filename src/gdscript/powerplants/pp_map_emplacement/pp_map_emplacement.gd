extends Node2D

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

@onready var bb_normal = $BbNormal
@onready var bb_in_construction = $BbInConstruction

var can_build: Array[PowerplantsManager.EngineTypeIds] = []
var powerplant_node_name: String = ""

func _ready():
	PowerplantsManager.powerplant_build_requested.connect(_on_powerplant_build_requested)
	
	# Will be disconnected after the first call emition
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
	
	
func _on_powerplant_build_requested(map_emplacement: Node, metrics: PowerplantMetrics):
	if map_emplacement == self:
		bb_normal.hide()
		
		if metrics.build_time_in_turns > 0:
			bb_in_construction.show()
		else:
			var pp_scene = PowerplantsManager.powerplant_scene.instantiate()
			add_child(pp_scene)
			powerplant_node_name = pp_scene.name
			pp_scene.set_metrics(metrics)
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
	_on_powerplant_build_requested(self, new_metrics)
