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

func _ready():
	percentage_label = get_parent().get_node("Percentage")
	name_key = PowerplantsManager.EngineTypeIds.keys()[plant_type]
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	Cursor.show_tooltip.emit(name_key)


func _on_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()


func _on_game_stats_updated(game_stats: Dictionary) -> void:
	var co2_emitted = game_stats.emissions_per_plant_type[plant_type]
	var total_co2_emitted = Gameloop.co2_emissions
	var percentage_emitted = co2_emitted / total_co2_emitted * 100.0
	percentage_label.text = str(percentage_emitted).pad_decimals(2) + " %"
