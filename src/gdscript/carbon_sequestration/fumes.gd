extends CPUParticles2D

var max_particles_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = false
	max_particles_amount = amount
	Gameloop.sequestrated_co2_updated.connect(_on_sequestrated_co2_updated)


func _on_sequestrated_co2_updated(value: float):
	var percentage_of_sequestrated_co2 = value / Gameloop.co2_emissions * 100.0
	
	if percentage_of_sequestrated_co2 > 0:
		var transparancy = color_ramp.get_color(0)
		transparancy.a = percentage_of_sequestrated_co2 / 100.0
		emitting = true
		color_ramp.set_color(0, transparancy)
	else:
		emitting = false
