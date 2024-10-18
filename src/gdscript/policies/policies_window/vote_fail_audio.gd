extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	%AnimationPlayer.animation_finished.connect(_on_policy_voted)


func _on_policy_voted(anim_name: String):
	if anim_name == "Vote_no":
		play()
