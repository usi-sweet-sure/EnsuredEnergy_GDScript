extends Sprite2D

# This is a supposition on the maximum value players could get to.
# This value may seems low, but some powerplants only add like 12 in land use
# So we have to be this low to see the arrow move.
# 
# Just in case users go over that value, we clamp the value.
var land_use_max_value = 300
# Since we clamp the value above. When the land use is above the clamp,
# we make the arrow jitter so the user has a visual indicator that they are
# above the max, and that reducing land use of only a small value may not be
# enough to make the arrow go lower
# This is a good solution since some pp add around 100 and others less than 1
@export var arrow_shake_amplitude_in_degrees := 2
@export var arrow_shake_speed_in_s := 0.1
var time_elapsed_since_last_shake := 0.0
var shake_arrow := false

func _ready():
	Gameloop.land_use_updated.connect(_on_land_use_updated)
	_on_land_use_updated(Gameloop.land_use)
	
func _process(delta):
	time_elapsed_since_last_shake += delta
	
	if shake_arrow && time_elapsed_since_last_shake > arrow_shake_speed_in_s:
		time_elapsed_since_last_shake = 0
		rotation_degrees += arrow_shake_amplitude_in_degrees
		arrow_shake_amplitude_in_degrees *= -1
	
	
func _on_land_use_updated(land_use: float):
	# The arrow rotation percentage goes from -75% (full left) to 75% (full right)
	# No land use points the arrow at -75%
	var arrow_was_shaking = shake_arrow
	shake_arrow = land_use > land_use_max_value
	var arrow_value = remap(clamp(land_use, 0, land_use_max_value), 0, land_use_max_value, -75, 75)
	
	if not arrow_was_shaking or not shake_arrow:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", arrow_value, 0.5)
