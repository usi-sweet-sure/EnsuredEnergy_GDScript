extends Node2D

@onready var upgrades_effects: Array[Array] = [
	[$Upgrades/Highlight0],
	[$Upgrades/Cover1, $Upgrades/Highlight1],
	[$Upgrades/Cover2, $Upgrades/Highlight2],
	[$Upgrades/Highlight3],
	[$Upgrades/Highlight4],
	[$Upgrades/Highlight5, $Upgrades/Cover5, $Upgrades/Cover5_2],
	[$Upgrades/Highlight6, $Upgrades/Cover6],
	[],
	[],
	[],
	[],
	[],
	[],
	[],
	[],
	[$Level15/Highlight7, $Level15/Highlight5, $Level15/Highlight6, $Level15/Cover6, $Level15/Cover5, $Level15/Cover5_2, $Level15/Highlight3, $Level15/Highlight0, $Level15/Cover1, $Level15/Highlight4, $Level15/Cover2, $Level15/Highlight1, $Level15/Highlight2],
]

func _ready() -> void:
	var pp_scene: PpScene = get_parent()
	pp_scene.powerplant_activated.connect(effects_on)
	pp_scene.powerplant_deactivated.connect(effects_off)
	pp_scene.powerplant_upgraded.connect(_on_powerplant_upgraded)
	pp_scene.powerplant_downgraded.connect(_on_powerplant_downgraded)


func effects_off(_metrics: PowerplantMetrics):
	for effects in upgrades_effects:
		for effect in effects:
			effect.hide()
	
	
func effects_on(metrics: PowerplantMetrics):
	var counter = 0
	
	while counter <= metrics.current_upgrade:
		for effect in upgrades_effects[counter]:
				effect.show()
		counter += 1


func _on_powerplant_upgraded(metrics: PowerplantMetrics):
	var effects_to_show = upgrades_effects[metrics.current_upgrade]
	
	for effect in effects_to_show:
		effect.show()


func _on_powerplant_downgraded(metrics: PowerplantMetrics):
	var effects_to_hide = upgrades_effects[metrics.current_upgrade + 1]
	
	for effect in effects_to_hide:
		effect.hide()

	
