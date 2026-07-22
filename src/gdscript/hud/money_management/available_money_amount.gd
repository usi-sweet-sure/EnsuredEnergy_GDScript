extends Control

@onready var sign_label: Label = $Sign/SignLabel
@onready var digitLabels := [
		$Digit3/Digit3Label, 
		$Digit2/Digit2Label, 
		$Digit1/Digit1Label, 
		$Digit0/Digit0Label
	]

func _ready():
	MoneyManager.available_money_amount_updated.connect(_on_available_money_amount_updated)
	_on_available_money_amount_updated(MoneyManager.available_money_amount)

func _on_available_money_amount_updated(amount: float):
	sign_label.text = "-" if amount < 0 else ""
	
	var digits := str(round(abs(amount))).pad_decimals(0)
	var maxDigits = digitLabels.size()
	var digitsLength = digits.length()
	var i = 0
	
	while i < maxDigits:
		digitLabels[i].text = ""
		i += 1
	
	i = 0
	while i < digitsLength:
		digitLabels[maxDigits - (digitsLength - i)].text = digits[i]
		i += 1
