extends ColorRect

@onready var debug_text: RichTextLabel = $MarginContainer/RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#Gameloop.player_name_updated.connect(_update_text)
	#Gameloop.energy_supply_updated_winter.connect(_update_text)
	#Gameloop.energy_supply_updated_summer.connect(_update_text)
	#Gameloop.energy_demand_updated_winter.connect(_update_text)
	#Gameloop.energy_demand_updated_summer.connect(_update_text)
	#Gameloop.imported_energy_amount_updated.connect(_update_text)
	#MoneyManager.borrowed_money_amount_updated.connect(_update_text)
	#MoneyManager.players_own_money_amount_updated.connect(_update_text)
	#MoneyManager.available_money_amount_updated.connect(_update_text)
	#Gameloop.land_use_updated.connect(_update_text)
	#Gameloop.co2_emissions_updated.connect(_update_text)
	#Gameloop.most_recent_shock_updated.connect(_update_text)
	#Gameloop.current_turn_updated.connect(_update_text)
	#MoneyManager.total_production_costs_updated.connect(_update_text)
	#MoneyManager.energy_import_cost_updated.connect(_update_text)
	#MoneyManager.building_costs_updated.connect(_update_text)
	#Gameloop.next_turn.connect(_on_signal_with_no_value)
	#Gameloop.player_name_updated.connect(_update_text)
	#Context.survey_token_updated.connect(_update_text)


func _on_close_button_pressed():
	$"../OpenDebugFrameButton".show()
	hide()


func _on_open_debug_frame_button_pressed():
	$"../OpenDebugFrameButton".hide()
	_update_text(0)
	show()
	
	
func _on_signal_with_no_value():
	_update_text(0)

func _update_text(_val):
	var entries: Array[String] = [
		"Player name: [b]" + Gameloop.player_name + "[/b]\n",
		"Current turn: [b]" + str(Gameloop.current_turn) + "[/b]\n\n",
		
		"[b]Energy[/b]\n",
		"Summer demand: [b]" + str(Gameloop.demand_summer) + "[/b]\n",
		"Winter demand: [b]" + str(Gameloop.demand_winter) + "[/b]\n",
		"Summer supply: [b]" + str(Gameloop.supply_summer) + "[/b]\n",
		"Winter supply: [b]" + str(Gameloop.supply_winter) + "[/b]\n",
		"Winter supply imports: [b]" + str(Gameloop.imported_energy_amount) + "[/b]\n\n",
		
		"[b]Money[/b]\n",
		"Available money for this turn: [b]" + str(MoneyManager.available_money_amount) + "[/b]\n",
		"Available money on next turn: [b]" + str(MoneyManager.get_money_for_next_turn()) + "[/b]\n",
		"Start money: [b]" + str(MoneyManager.start_money) + "[/b]\n",
		"Income per turn: [b]" + str(MoneyManager.money_per_turn) + "[/b]\n",
		"Player's own money: [b]" + str(MoneyManager.players_own_money_amount) + "[/b]\n",
		"Borrowed money amount: [b]" + str(MoneyManager.borrowed_money_amount) + "[/b]\n",
		"Debt percentage on borrowed money: [b]" + str(MoneyManager.debt_percentage_on_borrowed_money) + "[/b]\n",
		"Building costs: [b]" + str(MoneyManager.building_costs) + "[/b]\n",
		"Total production costs: [b]" + str(MoneyManager.total_production_costs) + "[/b]\n",
		"Production costs modifier: [b]" + str(MoneyManager.production_costs_modifier) + "[/b]\n",
		"Imports costs: [b]" + str(MoneyManager.energy_import_cost) + "[/b]\n\n",
		
		"[b]Environment[/b]\n",
		"Land use: [b]" + str(Gameloop.land_use) + "[/b]\n",
		"CO2 emissions: [b]" + str(Gameloop.co2_emissions) + "[/b]\n\n",
		
		"[b]Context[/b]\n",
		"res_name: [b]" + str(Context.res_name) + "[/b]\n",
		"survey_token: [b]" + str(Context.survey_token) + "[/b]\n",
	]
	
	debug_text.text = ""
	for entry in entries:
		debug_text.text += entry
