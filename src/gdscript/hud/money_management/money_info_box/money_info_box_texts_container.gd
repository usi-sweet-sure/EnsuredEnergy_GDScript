extends VBoxContainer

@onready var more_info_texts = [
	$BudgetText,
	$ProductionText,
	$BuildingText,
	$ImportsText,
	$LoanText,
]


func _ready() -> void:
	for text in more_info_texts:
		text.hide()
		

func _on_more_money_info_button_pressed():
	for text in more_info_texts:
		text.visible = not text.visible
