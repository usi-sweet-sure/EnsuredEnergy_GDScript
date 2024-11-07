extends Label


func _ready():
	MoneyManager.carbon_sequestration_production_costs_updated.connect(_on_cs_production_costs_updated)
	

func _on_cs_production_costs_updated(value: float):
	if value == 0:
		text = str(value) + "M CHF"
	else:
		text = str(value).pad_decimals(2) + "M CHF"
