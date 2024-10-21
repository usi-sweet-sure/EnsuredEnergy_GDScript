extends Control


@onready var off_1 = $Off1
@onready var on_1 = $On1
@onready var off_2 = $Off2
@onready var on_2 = $On2


# Called when the node enters the scene tree for the first time.
func _ready():
	off_1.show()
	off_2.show()
	on_1.hide()
	on_2.hide()
	PolicyManager.policy_voted.connect(_on_policy_voted)


func _on_policy_voted(_vote_passed: bool):
	var all_voted_policies = PolicyManager.voted_policies
	var number_of_passed_env_policies = 0
	
	for voted_policy in all_voted_policies:
		var policy: Policy = voted_policy.policy
		var passed = voted_policy.passed
		print(policy.inspector_id)
		
		if policy.inspector_id == "ENERGY CAMPAIGN" and passed:
			number_of_passed_env_policies += 1
	
	
	if number_of_passed_env_policies == 0:
		off_1.show()
		off_2.show()
		on_1.hide()
		on_2.hide()
	elif number_of_passed_env_policies == 1:
		off_1.hide()
		off_2.show()
		on_1.show()
		on_2.hide()
	elif number_of_passed_env_policies == 2:
		off_1.hide()
		off_2.hide()
		on_1.show()
		on_2.show()


func _on_led_entered():
	Cursor.show_tooltip.emit("+ 10%")


func _on_led_exited():
	Cursor.hide_tooltip.emit()
