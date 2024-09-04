extends ProgressBar


enum Season {WINTER, SUMMER}
@export var season: Season
@export var green_bar: Resource
@export var red_bar: Resource

@onready var info_box = $BarInfo
@onready var info_text = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText
@onready var info_text_2 = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText2
@onready var demand_line = $DemandLine

var max_value_set := false
# Called when the node enters the scene tree for the first time.


func _ready():
	Gameloop.hide_energy_bar_info_requested.connect(_on_hide_info_box)
	# Determines which season the bar will be monitoring
	match season:
		Season.WINTER:
			Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
			Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
			Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated)

			_on_energy_supply_updated(Gameloop.supply_winter)
		Season.SUMMER:
			Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)
			Gameloop.energy_demand_updated_summer.connect(_on_energy_demand_updated)
			
			_on_energy_supply_updated(Gameloop.supply_summer)


func _process(delta):
	change_bar_color()
	
	# The bars will have the same max_value and min_value, wich is the maximum demand
	# between winter and summer.
	# It's set once at the beginning and must not change again
	if not max_value_set and Gameloop.demand_winter != 0.0 and Gameloop.demand_summer != 0.0:
		max_value = max(Gameloop.demand_winter * 1.35, Gameloop.demand_summer * 1.35)
		min_value = 700
		max_value_set = true
		
		var bar_height = size.x
		match season:
			Season.WINTER:
				demand_line.position.x = remap(Gameloop.demand_winter, min_value, max_value, 0, bar_height)
				print(demand_line.position.x)
				#demand_line.position.x = bar_height / (max_value - min_value) * Gameloop.demand_winter
			Season.SUMMER:
				demand_line.position.x = remap(Gameloop.demand_summer, min_value, max_value, 0, bar_height)
				#demand_line.position.x = bar_height / (max_value - min_value) * Gameloop.demand_summer

func _on_energy_demand_updated(demand: float):
	var bar_height = size.x
	match season:
			Season.WINTER:
				demand_line.position.x = remap(Gameloop.demand_winter, min_value, max_value, 0, bar_height)
			Season.SUMMER:
				demand_line.position.x = remap(Gameloop.demand_summer, min_value, max_value, 0, bar_height)

# Updates the progress bar
func _on_energy_supply_updated(supply: float):
	var new_value := 0.0
	
	if season == Season.WINTER:
		new_value = supply + Gameloop.imported_energy_amount
	else:
		new_value = supply
		
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", new_value, 0.5)
	
	
# Updates the progress bar
func _on_imported_energy_amount_updated(amount: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", Gameloop.supply_winter + amount, 0.5)
		
		
func change_bar_color():
	match season:
		Season.SUMMER:
			if Gameloop.supply_summer >= Gameloop.demand_summer:
				self["theme_override_styles/fill"] = green_bar
			else:
				self["theme_override_styles/fill"] = red_bar
				
		Season.WINTER:
			if Gameloop.supply_winter + Gameloop.imported_energy_amount >= Gameloop.demand_winter:
				self["theme_override_styles/fill"] = green_bar
			else:
				self["theme_override_styles/fill"] = red_bar
		
		
# Displays basic information on energy supply and demand
func _on_bar_button_pressed():
	match season:
		Season.WINTER:
			Gameloop.hide_energy_bar_info_requested.emit(Season.SUMMER)
		Season.SUMMER:
			Gameloop.hide_energy_bar_info_requested.emit(Season.WINTER)
	info_box.visible = not info_box.visible
	

# Displays more detailed information about energy supply and demand
func _on_more_info_pressed():
	info_text.visible = not info_text.visible
	info_text_2.visible = not info_text_2.visible


# Hides the info box
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		info_text.hide()
		info_text_2.hide()
		info_box.hide()


func get_season_text(season_value: int):
	match season_value:
		0: return "Winter"
		1: return "Summer"


func _on_hide_info_box(season_to_hide: Season):
	if season_to_hide == season:
		info_box.hide()
