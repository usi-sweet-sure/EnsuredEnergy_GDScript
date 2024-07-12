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


var is_alive: bool = true
var upgrade: int = 1
var mult_factor: float = 0.025
var cnv_capacity: int = 10

@onready var delete_button = $Delete
@onready var build_info = $BuildInfo

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

var plant_name_to_cnv_cap = {
					"gas": "cnv_gas_gas",
	"nuclear": "cnv_nuc_nuc",
	"river": "cnv_riv_hyd",
	"hydro": "cnv_res_hyd",
	"waste": "cnv_wst_wst",
	"biomass": "cnv_woo_woo",
	"solar": "cnv_sol_sol",
	"wind": "cnv_wnd_wnd",
	"pump": "cnv_pmp_hyd",
	"geothermal": "prm_dom_geo", 
					}
					
var plant_name_to_ups_id = {
			"gas": "186",
			"nuclear": "151",
			"river": "162",
			"hydro": "163",
			"waste": "189",
			"biomass": "192",
			"solar": "170",
			"wind": "171",
			"pump": "379",
			"geothermal": "246"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	
	_update_info()
	

func _update_info():
	# updates the energy produced by a plant in summer and winter
	$ResRect/EnergyS.text = str(availability.x * capacity).pad_decimals(1)
	$ResRect/EnergyW.text = str(availability.y * capacity).pad_decimals(1)
	$BuildInfo/EnergyContainer/Summer/BuildMenuNumHole/SummerE.text = str(availability.x * capacity).pad_decimals(1)
	$BuildInfo/EnergyContainer/Winter/BuildMenuNumHole2/WinterE.text = str(availability.y * capacity).pad_decimals(1)
	
	# TODO for pollution, land use and production costs
	
	# multiplier upgrade infos
	if max_upgrade > 1:
		$BuildInfo/EnergyContainer/Multiplier.show()
		$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)
		$BuildInfo/EnergyContainer/Multiplier/Inc.show()
	$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)

# TODO only call once at the start of the game, not every request
# add the model numbers to the plant
func _on_request_finished(result, response_code, headers, body):
	var model_key = plant_name_to_model[plant_name]
	var plant_id = plant_name_to_cnv_cap[plant_name]
	if plant_name == "nuclear":
		capacity = int(Context1.ctx1[0][model_key]) / 1000 / 3 # there's 3 nuclear plants
	if plant_name == "hydro" || plant_name == "river":
		capacity = int(Context1.ctx1[0][model_key]) / 1000 / 2
		cnv_capacity = int(Context1.ctx1[0][plant_id])
	else:
		capacity = int(Context1.ctx1[0][model_key]) / 1000
		cnv_capacity = int(Context1.ctx1[0][plant_id])
	_update_info()
	Context1.http1.request_completed.disconnect(_on_request_finished)

func _on_info_button_pressed():
	$BuildInfo.visible = !$BuildInfo.visible


func _on_mult_inc_pressed():
	if upgrade < max_upgrade:
		upgrade += 1
		$BuildInfo/EnergyContainer/Multiplier/Dec.show()
		
		var plant_id = plant_name_to_ups_id[plant_name]
		cnv_capacity *= (1 + (upgrade * mult_factor))
		capacity *= (1 + (upgrade * mult_factor))
		Context1.prm_id = plant_id
		Context1.yr = "2025"
		Context1.tj = cnv_capacity
		Context1.prm_ups()
		
		_update_info()
		Gameloop._update_supply()
		


func _on_mult_dec_pressed():
	if upgrade > 1:
		var plant_id = plant_name_to_ups_id[plant_name]
		cnv_capacity /= (1 + (upgrade * mult_factor))
		capacity /= (1 + (upgrade * mult_factor))
		#Context1.prm_ups(Context1.res_id, plant_id, "2025", cnv_capacity)
		upgrade -= 1
		
		_update_info()
		Gameloop._update_supply()


func _on_switch_toggled(toggled_on):
	pass # Replace with function body.
