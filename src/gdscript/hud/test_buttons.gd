# To be deleted, edit this script as you wish
extends Control

@onready var button_top = $ButtonTop
@onready var button_bottom = $ButtonBottom


func _ready():
	button_top.text = "Open graphs"
	button_bottom.text = "pick production cost shock"


func _on_button_top_pressed():
	Gameloop.toggle_graphs.emit()
	
	
func _on_button_bottom_pressed():
	var wanted_shock_title = "SHOCK_INC_RAW_COST_10_TITLE"
	var wanted_shock: Shock
	
	for i in ShockManager.shocks:
		if i.title_key == wanted_shock_title:
			wanted_shock = i

	wanted_shock.apply()
