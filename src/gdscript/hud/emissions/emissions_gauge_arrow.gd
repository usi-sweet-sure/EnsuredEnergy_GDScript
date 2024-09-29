extends Sprite2D

# This is a supposition on the maximum value players could get to.
# This value may seems low, but some powerplants only add like 0.03 in emission
# So we have to be this low to see the arrow move.
# Just in case users go over that value, we clamp the value.
var emissions_max_value = 5
# Since we clamp the value above. When the emission is above the clamp,
# we make the arrow jitter so the user has a visual indicator that they are
# above the max, and that reducing emissions of only a small value may not be
# enough to make the arrow go lower
@export var arrow_shake_amplitude_in_degrees := 2
@export var arrow_shake_speed_in_s := 0.1
var time_elapsed_since_last_shake := 0.0
var shake_arrow := false

func _ready():
	Gameloop.co2_emissions_updated.connect(_on_emissions_updated)
	_on_emissions_updated(Gameloop.co2_emissions)
	
func _process(delta):
	time_elapsed_since_last_shake += delta
	
	if shake_arrow && time_elapsed_since_last_shake > arrow_shake_speed_in_s:
		time_elapsed_since_last_shake = 0
		rotation_degrees += arrow_shake_amplitude_in_degrees
		arrow_shake_amplitude_in_degrees *= -1
	
	
func _on_emissions_updated(emissions: float):
	# The arrow rotation percentage goes from -75% (full left) to 75% (full right)
	# No emission points the arrow at -75%
	var arrow_was_shaking = shake_arrow
	shake_arrow = emissions > emissions_max_value
	var arrow_value = remap(clamp(emissions, 0, emissions_max_value), 0, emissions_max_value, -75, 75)
	
	if not arrow_was_shaking or not shake_arrow:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", arrow_value, 0.5)
