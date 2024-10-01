extends ColorRect

var metrics: PowerplantMetrics


# Called when the node enters the scene tree for the first time.
func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_available_money_updated)


func _on_available_money_updated(_value: float):
	visible = not MoneyManager.can_spend_the_money(metrics.building_costs + metrics.production_costs)
	

func _on_powerplant_metrics_updated(metrics_: PowerplantMetrics):
	metrics = metrics_.copy()
	visible = not MoneyManager.can_spend_the_money(metrics.building_costs + metrics.production_costs)
