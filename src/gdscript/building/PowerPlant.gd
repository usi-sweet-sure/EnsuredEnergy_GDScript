extends Node2D


@export var availability = Vector2(0.5, 0.5)
@export var capacity: int = 10
@export var plant_name: String = "gas"
@export var life_span: int = 11
@export var max_upgrade: int = 3
@export var build_time: int = 0
@export var build_cost: int = 100
@export var production_cost: float = 0
@export var pollution: float = 0
@export var land_use: float = 1


var is_alive: bool = true
var upgrade: int = 0
var mult_factor: float = 0.025
var cnv_capacity: float
var base_capacity

@onready var delete_button = $Delete
@onready var build_info = $BuildInfo
@onready var multiplier = $BuildInfo/EnergyContainer/Multiplier
@onready var summer_energy = $BuildInfo/EnergyContainer/Summer/BuildMenuNumCounter3/SummerE
@onready var winter_energy = $BuildInfo/EnergyContainer/Winter/BuildMenuNumCounter3/WinterE

var plant_name_to_model = {
	"GAS": "cnv_gas_ele",
	"NUCLEAR": "cnv_nuc_ele",
	"RIVER": "cnv_riv_hyd",
	"HYDRO": "cnv_res_hyd",
	"WASTE": "cnv_wst_ele",
	"BIOMASS": "cnv_woo_ele",
	"SOLAR": "cnv_sol_ele",
	"WIND": "cnv_wnd_ele",
	"PUMP": "cnv_pmp_ele",
	"GEOTHERMAL": "prm_dom_geo", 
	}

var plant_name_to_cnv_cap = {
					"GAS": "cnv_gas_gas",
	"NUCLEAR": "cnv_nuc_nuc",
	"RIVER": "cnv_riv_hyd",
	"HYDRO": "cnv_res_hyd",
	"WASTE": "cnv_wst_wst",
	"BIOMASS": "cnv_woo_woo",
	"SOLAR": "cnv_sol_sol",
	"WIND": "cnv_wnd_wnd",
	"PUMP": "cnv_pmp_hyd",
	"GEOTHERMAL": "prm_dom_geo", 
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
			"PUMP": "379",
			"GEOTHERMAL": "246"
}

var plant_name_to_metric_id = {
	"GAS_EMI": "met_emi_gas",
	"GAS_LAND": "met_lnd_gas",
	"GAS_COST": "met_cst_gas",
	"NUCLEAR_EMI": "met_emi_nuc",
	"NUCLEAR_LAND": "met_lnd_nuc",
	"NUCLEAR_COST": "met_cst_nuc",
	"HYDRO_EMI": "met_emi_hyd",
	"HYDRO_LAND": "met_lnd_hyd",
	"HYDRO_COST": "met_cst_hyd",
	"RIVER_EMI": "met_emi_hyd",
	"RIVER_LAND": "met_lnd_hyd",
	"RIVER_COST": "met_cst_hyd",
	"WASTE_EMI": "met_emi_wst",
	"WASTE_LAND": "met_lnd_wst",
	"WASTE_COST": "met_cst_wst",
	"BIOMASS_EMI": "met_emi_woo",
	"BIOMASS_LAND": "met_lnd_woo",
	"BIOMASS_COST": "met_cst_woo",
	"SOLAR_EMI": "met_emi_sol",
	"SOLAR_LAND": "met_lnd_sol",
	"SOLAR_COST": "met_cst_sol",
	"WIND_EMI": "met_emi_wnd",
	"WIND_LAND": "met_lnd_wnd",
	"WIND_COST": "met_cst_wnd",
	"GEOTHERMAL_EMI": "met_emi_geo",
	"GEOTHERMAL_LAND": "met_lnd_geo",
	"GEOTHERMAL_COST": "met_cst_bgs", #geothermal cost is broken
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Context1.http1.request_completed.connect(_on_request_finished)
	Gameloop.next_turn.connect(_check_life_span)
	
	_update_info()
	

func _update_info():
	# updates the energy produced by a plant in summer and winter
	$PreviewInfo/EnergyS.text = str(availability.x * capacity).pad_decimals(0)
	$PreviewInfo/EnergyW.text = str(availability.y * capacity).pad_decimals(0)
	summer_energy.text = str(availability.x * capacity).pad_decimals(0)
	winter_energy.text = str(availability.y * capacity).pad_decimals(0)
	
	# updates stats
	$BuildInfo/ColorRect/ContainerN/Prod.text = "-" + str(production_cost).pad_decimals(0)
	$BuildInfo/ColorRect/ContainerN/Poll.text = str(pollution).pad_decimals(2)
	$BuildInfo/ColorRect/ContainerN/Land.text = str(land_use).pad_decimals(2)
	
	# multiplier upgrade infos
	if max_upgrade > 1:
		$BuildInfo/EnergyContainer/Multiplier.show()
		$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)
		$BuildInfo/EnergyContainer/Multiplier/Inc.show()
	$BuildInfo/EnergyContainer/Multiplier/MultAmount.text = str(upgrade)
	
	# updates texts
	$NameRect/Name.text = tr(plant_name)
	$BuildInfo/Name.text = tr(plant_name)

# add the model numbers to the plant
func _on_request_finished(_result, _response_code, _headers, _body):
	var model_key = plant_name_to_model[plant_name]
	var plant_id = plant_name_to_cnv_cap[plant_name]
	var poll_key = plant_name_to_metric_id[plant_name + "_EMI"]
	var land_key = plant_name_to_metric_id[plant_name + "_LAND"]
	var cost_key = plant_name_to_metric_id[plant_name + "_COST"]
	
	if plant_name == "NUCLEAR":
		capacity = int(Context1.ctx1[0][model_key]) / 100 / 3 # there's 3 nuclear plants
		pollution = float(Context1.ctx1[0][poll_key]) / 3
		land_use = float(Context1.ctx1[0][land_key]) / 3
		production_cost = float(Context1.ctx1[0][cost_key]) / 10 / 3
	if plant_name == "HYDRO" || plant_name == "RIVER":
		capacity = int(Context1.ctx1[0][model_key]) / 100 / 2
		cnv_capacity = float(Context1.ctx1[0][plant_id])
		pollution = float(Context1.ctx1[0][poll_key]) / 4 # needs to divide by the number of water plants
		land_use = float(Context1.ctx1[0][land_key]) / 4
		production_cost = float(Context1.ctx1[0][cost_key]) / 10 / 4
	else:
		capacity = int(Context1.ctx1[0][model_key]) / 100
		cnv_capacity = float(Context1.ctx1[0][plant_id])
		pollution = float(Context1.ctx1[0][poll_key])
		land_use = float(Context1.ctx1[0][land_key])
		production_cost = float(Context1.ctx1[0][cost_key]) / 10
	
	base_capacity = capacity
	_update_info()
	Context1.http1.request_completed.disconnect(_on_request_finished)
	Gameloop._update_supply()

func _on_info_button_pressed():
	$BuildInfo.visible = !$BuildInfo.visible


func _on_mult_inc_pressed():
	if upgrade < max_upgrade:
		$BuildInfo/EnergyContainer/Multiplier/Dec.show()
		
		upgrade += 1
		var plant_id = plant_name_to_ups_id[plant_name]
		var value = cnv_capacity + (cnv_capacity * mult_factor * upgrade) # !! Check rounding of the value in model
		capacity = base_capacity + (base_capacity * mult_factor * upgrade)
		Context1.prm_id = plant_id
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		Context1.tj = value
		Context1.prm_ups()
		
		_update_info()
		Gameloop._update_supply()
		


func _on_mult_dec_pressed():
	if upgrade > 0:
		upgrade -= 1
		var plant_id = plant_name_to_ups_id[plant_name]
		var value = cnv_capacity + (cnv_capacity * mult_factor * upgrade)
		capacity = base_capacity + (base_capacity * mult_factor * upgrade)
		Context1.prm_id = plant_id
		Context1.yr = Gameloop.year_list[Gameloop.current_turn]
		Context1.tj = value
		Context1.prm_ups()
		
		_update_info()
		Gameloop._update_supply()
		
func _connect_next_turn_signal():
	if !Gameloop.next_turn.is_connected(_hide_delete_on_next_turn):
		Gameloop.next_turn.connect(_hide_delete_on_next_turn)

func _hide_delete_on_next_turn():
	delete_button.hide()
	
func _check_life_span():
	if life_span <= Gameloop.current_turn:
		is_alive = false
		_on_switch_toggled(false)
		$BuildInfo/Switch.disabled = true #add disabled sprite

func _on_switch_toggled(toggled_on):
	is_alive = toggled_on
	
	if toggled_on:
		modulate = Color(1, 1, 1, 1)
		$BuildInfo/Switch/LEDOn.show()
		#play animation
		_update_info()
		add_to_group("PP")
	else:
		modulate = Color(0.8, 0.8, 0.8, 1)
		$BuildInfo/Switch/LEDOn.hide()
		#stop animation
		summer_energy.text = "0"
		winter_energy.text = "0"
		remove_from_group("PP")
		
	Gameloop._update_supply()
