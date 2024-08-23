extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	PolicyManager.personal_support_updated.connect(_on_personal_support_updated)
	_on_personal_support_updated(PolicyManager.personal_support)

func _on_personal_support_updated(support):
	value = support * 100.0
