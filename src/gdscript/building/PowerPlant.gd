extends Node2D


@export var availability = Vector2(0.5, 0.5)
@export var capacity: int = 10
@export var plant_name: String = "gas"
@export var life_span: int = 11
@export var max_upgrade: int = 3
@export var build_time: int = 0
@export var build_cost: int = 100
@export var production_cost: int = 0
@export var pollution: int = 0
@export var land_use: int = 1

@export var is_preview: bool = false


var is_alive: bool = true

var plant_name_to_model = {
	"gas": "cnv_gas_ele",
	"nuclear": "cnv_nuc_ele",
	"river": "cnv_riv_hyd",
	"hydro": "cnv_res_hyd",
	"waste": "cnv_wst_ele",
	"biomass": "cnv_woo_ele",
	"solar": "cnv_sol_ele",
	"wind": "cnv_wnd_ele",
	"pump": "cnv_pmp_ele",
	"geothermal": "prm_dom_geo", 
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	
	_update_info()
	
func _update_info():
	$ResRect/EnergyS.text = str(availability.x * capacity).pad_decimals(1)
	$ResRect/EnergyW.text = str(availability.y * capacity).pad_decimals(1)
	$BuildInfo/EnergyContainer/Summer/BuildMenuNumHole/SummerE.text = str(availability.x * capacity).pad_decimals(1)
	$BuildInfo/EnergyContainer/Winter/BuildMenuNumHole2/WinterE.text = str(availability.y * capacity).pad_decimals(1)

func _on_request_finished(result, response_code, headers, body):
	var model_key = plant_name_to_model[plant_name]
	if plant_name == "nuclear":
		capacity = int(Context1.ctx1[0][model_key]) / 1000 / 3
	if plant_name == "hydro" || plant_name == "river":
		capacity = int(Context1.ctx1[0][model_key]) / 1000 / 2
	else:
		capacity = int(Context1.ctx1[0][model_key]) / 1000
	_update_info()


# need to get this working...
func _on_hover_area_mouse_entered():
	if is_preview:
		$BuildInfo.show()


func _on_hover_area_mouse_exited():
	if is_preview:
		$BuildInfo.hide()


func _on_info_button_pressed():
	$BuildInfo.visible = !$BuildInfo.visible
