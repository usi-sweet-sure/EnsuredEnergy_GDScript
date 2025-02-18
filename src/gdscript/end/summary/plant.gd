extends TextureRect

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
) var plant_type: int = 0
var name_key = ""
var percentage_label: Label
var context = "emissions"
var game_stats = null
var tooltip = ""


func _ready():
	percentage_label = get_parent().get_node("Percentage")
	name_key = PowerplantsManager.EngineTypeIds.keys()[plant_type]
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered() -> void:
	Cursor.show_tooltip.emit(tooltip)


func _on_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()


func _on_game_stats_updated(game_stats_: Dictionary) -> void:
	game_stats = game_stats_
	_update()


func _on_summary_requested(type: String) -> void:
	context = type
	_update()


func _update():
	tooltip = name_key
	if game_stats != null:
		var plant_value = 0
		var total_value = 1
		
		if context == "emissions":
			plant_value = game_stats.emissions_per_plant_type[plant_type]
			total_value = Gameloop.co2_emissions
		elif context == "land_use":
			plant_value = game_stats.land_use_per_plant_type[plant_type]
			total_value = Gameloop.land_use
		elif context == "money":
			plant_value = game_stats.production_costs_per_plant_type[plant_type]
			total_value = MoneyManager.total_production_costs
		elif context == "energy":
			var winter = game_stats.winter_energy_per_plant_type[plant_type]
			var summer = game_stats.summer_energy_per_plant_type[plant_type]
			
			plant_value = winter + summer
			total_value = Gameloop.supply_winter + Gameloop.supply_summer
			
			# More info in tooltip
			var winter_percentage = winter / Gameloop.supply_winter * 100.0
			var summer_percentage = summer / Gameloop.supply_summer * 100.0
			tooltip += "\n" + tr("SUMMER") + " " + str(summer_percentage).pad_decimals(2) + " %"
			tooltip += "\n" + tr("WINTER") + " " + str(winter_percentage).pad_decimals(2) + " %"
			tooltip += "\n" + tr("TOTAL") + " " + str(plant_value / total_value * 100.0).pad_decimals(2) + " %"

		var plant_percentage = plant_value / total_value * 100.0
		percentage_label.text = str(plant_percentage).pad_decimals(2) + " %"
	else:
		pass
