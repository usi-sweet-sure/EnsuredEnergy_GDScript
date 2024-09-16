extends Node

signal toggle_menu(can_build: Array[EngineTypeIds])

# Ids used to identify the powerplants inside the engine in a consistent manner
enum EngineTypeIds {
	SOLAR,
	WIND,
	GAS,
	WASTE,
	BIOMASS,
	BIOGAS,
	NUCLEAR,
	CARBON_SEQUESTRATION,
	HYDRO,
	RIVER,
}

# Stores the data of the powerplants gotten from the model
# Each powerplant type data is stored at the index corresponding to EngineTypeIds
var powerplants_metrics = []

# In the same order as EngineTypeIds
var powerplants_model_id = [
	"168", # Solar
	"169", # Wind
	"187", # Gas
	"190", # Waste
	"193", # Biomass
	"173", # Biogas
	"152", # Nuclear
	"774", # Carbon sequestration
	"161", # Hydro
	"160", # River
]

# In the same order as EngineTypeIds
var powerplants_ups_id = [
	"170", # Solar
	"171", # Wind
	"186", # Gas
	"189", # Waste
	"192", # Biomass
	"175", # Biogas
	"151", # Nuclear
	"774", # Carbon sequestration
	"163", # Hydro
	"162", # River
]

# In the same order as EngineTypeIds
var powerplants_metrics_id = [
	{ # Solar
		"production_cost": "328",
		"emission": "258",
		"land_use": "288",
		"availability": "338",
	},
	{ # Wind
		"production_cost": "329",
		"emission": "259",
		"land_use": "289",
		"availability": "339",
	},
	{ # Gas
		"production_cost": "324",
		"emission": "254",
		"land_use": "284",
		"availability": "334",
	},	
	{ # Waste
		"production_cost": "325",
		"emission": "255",
		"land_use": "285",
		"availability": "335",
	},
	{ # Biomass
		"production_cost": "326",
		"emission": "256",
		"land_use": "286",
		"availability": "336",
	},
	{ # Biogas
		"production_cost": "327",
		"emission": "257",
		"land_use": "287",
		"availability": "337",
	},
	{ # Nuclear
		"production_cost": "322",
		"emission": "252",
		"land_use": "282",
		"availability" : "332",
	},
	{ # Carbon sequestration
		"production_cost": "526",
		"emission": "525",
		"land_use": "",
		"availability": "",
	},
	{ # Hydro
		"production_cost": "460",
		"emission": "458",
		"land_use": "459",
		"availability": "461",
	},
	{ # River
		"production_cost": "323",
		"emission": "253",
		"land_use": "283",
		"availability": "333",
	},
]


func _ready():
	Context.http.request_completed.connect(_on_request_finished)


func _on_request_finished(_result, _response_code, _headers, _body):
	if Context.ctx != null:
		for type in EngineTypeIds:
			_store_powerplant_metrics(type)


func _store_powerplant_metrics(engine_type_id: EngineTypeIds):
		var model_key: String = powerplants_model_id[engine_type_id]
		var plant_id: String = ""
		var pollution_key: String = ""
		var land_use_key: String = ""
		var production_cost_key: String = ""
		var availability_key: String = ""
