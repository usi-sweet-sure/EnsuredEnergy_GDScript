extends ProgressBar

enum Season {WINTER, SUMMER}
@export var season: Season

@onready var info_box = $BarInfo
@onready var info_text = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText
@onready var info_text_2 = $BarInfo/MarginContainer/MarginContainer/VBoxContainer/InfoText2


# Called when the node enters the scene tree for the first time.
func _ready():
	match season:
		Season.WINTER:
			Main.energy_supply_updated_winter.connect(_on_energy_supply_updated)
		Season.SUMMER:
			Main.energy_supply_updated_summer.connect(_on_energy_supply_updated)
			

func _on_energy_supply_updated(supply):
	value = supply
		
		
func _on_bar_button_pressed():
	info_box.visible = not info_box.visible
	

func _on_more_info_pressed():
	info_text.visible = not info_text.visible
	info_text_2.visible = not info_text_2.visible


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		info_text.hide()
		info_text_2.hide()
		info_box.hide()
