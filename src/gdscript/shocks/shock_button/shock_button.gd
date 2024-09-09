extends Node2D

class_name ShockButton

signal shock_changed

var shock: Shock:
	set(new_shock):
		shock = new_shock
		shock_changed.emit(shock)
		
var spawn_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Gameloop.locale_updated.connect(_on_locale_updated)
	spawn_position = position


func _on_locale_updated(_locale):
	shock_changed.emit(shock)


func get_button():
	return get_node("TextureButton")


func _on_texture_button_mouse_entered():
	ShockManager.shock_button_entered.emit(shock)
	
	if shock.title_key == Gameloop.most_recent_shock.title_key:
		ShockManager.toggle_shock_buttons.emit(true)


func _on_texture_button_mouse_exited():
		ShockManager.shock_button_exited.emit(shock)
