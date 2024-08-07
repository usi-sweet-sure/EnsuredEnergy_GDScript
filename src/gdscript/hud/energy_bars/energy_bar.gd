extends ProgressBar

enum Season {WINTER, SUMMER}
@export var season: Season
@export var green_bar: Resource
@export var red_bar: Resource

@onready var info_box = $BarInfo
@onready var info_text = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText
@onready var info_text_2 = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText2
@onready var demand_line = $DemandLine


# Called when the node enters the scene tree for the first time.
func _ready():
	# The bars will have the same max_value, wich is the maximum demand
	# between winter and summer
	max_value = max(Gameloop.demand_winter * 1.5, Gameloop.demand_summer * 1.5)
	
	# Determines which season the bar will be monitoring
	match season:
		Season.WINTER:
			Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
			Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated)
			Gameloop.imported_energy_amount_updated.connect(_on_imported_energy_amount_updated)
			
			# The bars are created after the gameloop sets the variables the first time,
			# so we have to updates the bars manually when they're created
			_on_energy_demand_updated(Gameloop.demand_winter)
			_on_energy_supply_updated(Gameloop.supply_winter)
		Season.SUMMER:
			Gameloop.energy_supply_updated_summer.connect(_on_energy_supply_updated)
			Gameloop.energy_demand_updated_summer.connect(_on_energy_demand_updated)
			
			# The bars are created after the gameloop sets the variables the first time,
			# so we have to updates the bars manually when they're created
			_on_energy_demand_updated(Gameloop.demand_summer)
			_on_energy_supply_updated(Gameloop.supply_summer)

# Updates the position of the line representing the demand and the max value of the progress bar
func _on_energy_demand_updated(demand):
	var bar_height = size.x
	demand_line.position.x = bar_height / max_value * demand


# Updates the progress bar
func _on_energy_supply_updated(supply):
	var new_value = 0
	
	if season == Season.WINTER:
		new_value = supply + Gameloop.imported_energy_amount
	else:
		new_value = supply
		
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", new_value, 0.5)
	
# Updates the progress bar
func _on_imported_energy_amount_updated(amount):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", Gameloop.supply_winter + amount, 0.5)
		
func change_bar_color():
	match season:
		Season.SUMMER:
			if value >= Gameloop.demand_summer:
				self["theme_override_styles/fill"] = green_bar
			else:
				self["theme_override_styles/fill"] = red_bar
				
		Season.WINTER:
			if value + Gameloop.imported_energy_amount >= Gameloop.demand_winter:
				self["theme_override_styles/fill"] = green_bar
			else:
				self["theme_override_styles/fill"] = red_bar
		
# Displays basic information on energy supply and demand
func _on_bar_button_pressed():
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


func _on_value_changed(value):
	change_bar_color()
