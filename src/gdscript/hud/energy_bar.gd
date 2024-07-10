extends ProgressBar

enum Season {WINTER, SUMMER}
@export var season: Season

@onready var info_box = $BarInfo
@onready var info_text = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText
@onready var info_text_2 = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText2
@onready var demand_line = $Target


# Called when the node enters the scene tree for the first time.
func _ready():
	match season:
		Season.WINTER:
			Main.energy_supply_updated_winter.connect(_on_energy_supply_updated)
			Main.energy_demand_updated_winter.connect(_on_energy_demand_updated)
			
			# To get the first value
			_on_energy_supply_updated(Main.supply_winter)
			_on_energy_demand_updated(Main.demand_winter)
		Season.SUMMER:
			Main.energy_supply_updated_summer.connect(_on_energy_supply_updated)
			Main.energy_demand_updated_summer.connect(_on_energy_demand_updated)
			_on_energy_supply_updated(Main.supply_summer)
			_on_energy_demand_updated(Main.demand_summer)

# Updates the position of the line representing the energy supply to reach
func _on_energy_demand_updated(demand):
	# E. this does not work yet
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
