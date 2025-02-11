extends TextureRect

@export var plant_name: String

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	Cursor.show_tooltip.emit(plant_name)


func _on_mouse_exited() -> void:
	Cursor.hide_tooltip.emit()
