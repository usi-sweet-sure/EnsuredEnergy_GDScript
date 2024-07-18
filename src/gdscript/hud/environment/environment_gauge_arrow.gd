extends Sprite2D


func _ready():
	Gameloop.biodiversity_percentage_updated.connect(_on_environment_data_updated)
	Gameloop.land_use_percentage_updated.connect(_on_environment_data_updated)
	
	_on_environment_data_updated(0)

func _on_environment_data_updated(_percentage):
	# The arrow rotation percentage goes from -75% (full left) to 75% (full right)
	# Land use turns the arrow to the left, biodiversitiy to the right
	# Land use 100% and biodiversity 0% should point the arrow at -75%
	# E. that's my assumption, but the arrow is not pointing the same as in
	# the c-sharp version, so the weights may be updated
	var land_use_percentage_normalised = Gameloop.land_use_percentage * 75 / 100.0
	var biodiversity_percentage_normalised = Gameloop.biodiversity_percentage * 75 / 100.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees",
			clamp(biodiversity_percentage_normalised - land_use_percentage_normalised, -75, 75), 0.5)
