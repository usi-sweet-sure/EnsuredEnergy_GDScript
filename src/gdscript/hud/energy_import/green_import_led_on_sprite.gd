extends Sprite2D


func _ready():
	Gameloop.green_energy_import_on_updated.connect(_on_green_energy_import_on_updated)

func _on_green_energy_import_on_updated(toggled_on: bool):
	visible = toggled_on
