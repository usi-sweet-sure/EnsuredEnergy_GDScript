extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.energy_policies_support_updated.connect(_on_energy_policies_support_updated)
	_on_energy_policies_support_updated(PolicyManager.energy_policies_support)


func _on_energy_policies_support_updated(value: float):
	text = str(value * 100).pad_decimals(0) + "%"
