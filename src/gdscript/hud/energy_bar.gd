extends ProgressBar

enum Season {WINTER, SUMMER}
@export var season: Season


# Called when the node enters the scene tree for the first time.
func _ready():
	match season:
		Season.WINTER:
			print("winter")
			Main.supply_updated_winter.connect(_on_energy_supply_updated)
		Season.SUMMER:
			print("summer")
			Main.supply_updated_summer.connect(_on_energy_supply_updated)
			

func _on_energy_supply_updated(supply):
	value = supply
