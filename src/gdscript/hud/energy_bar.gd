extends ProgressBar

enum Season {WINTER, SUMMER}
@export var season: Season

@onready var info_box = $BarInfo
@onready var info_text = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText
@onready var info_text_2 = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText2
@onready var demand_line = $Target


# Called when the node enters the scene tree for the first time.
func _ready():
	# Determines which season the bar will be monitoring
	match season:
		Season.WINTER:
			Gameloop.energy_supply_updated_winter.connect(_on_energy_supply_updated)
			Gameloop.energy_demand_updated_winter.connect(_on_energy_demand_updated)
			
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

# Updates the position of the line representing the energy supply to reach
func _on_energy_demand_updated(demand):
	# E. this does not work yet
	print(get_season_text(season) + " demand ")
	var demand_normalized = demand - self.min_value / self.max_value - self.min_value
	
	demand_line.position = Vector2(
		demand_line.position.x + demand_normalized,
		demand_line.position.y
	)

# Updates the progress bar
func _on_energy_supply_updated(supply):
	value = supply
		
		
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

func get_season_text(season: int):
	match season:
		0: return "Winter"
		1: return "Summer"
