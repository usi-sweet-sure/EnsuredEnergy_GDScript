extends CheckButton


func _on_toggled(toggled_on: bool):
	Gameloop.green_energy_import_on = toggled_on
