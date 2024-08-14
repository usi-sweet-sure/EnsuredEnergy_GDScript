extends Label

@onready var roll_sprite: Sprite2D = $ColorRect
var original_position

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.next_turn.connect(_on_next_turn)
	original_position = position


func _on_next_turn():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", original_position, 0.15)
	
	var all_power_plants = get_tree().get_nodes_in_group("PP")
	for power_plant in all_power_plants:
		if power_plant.is_alive and power_plant.is_nuclear():
			if Gameloop.current_turn == power_plant.life_span:
				tween.tween_property(self, "position", Vector2(self.position.x - roll_sprite.get_rect().size.x - 60, self.position.y), 0.15)
