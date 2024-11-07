extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_shock_changed(shock: Shock):
	text = "[center][font_size=25]" + tr(shock.title_key) + "[/font_size]\n\n" + tr(shock.text_key)
	
	if shock.met_requirements_conditions_when_picked:
		text += "\n\n[font_size=20]" + tr("REQUIREMENTS_MET") + "[/font_size]\n" + tr(shock.requirements_met_text_key)
		
	if shock.chosen_reaction_index != -1:
		text += "\n\n[font_size=20]" +  tr("ACTION_TAKEN") + "[/font_size]\n" + tr(shock.player_reactions_texts[shock.chosen_reaction_index])
	
	text += "[/center]"
	
	pivot_offset.x = size.x
	pivot_offset.y = size.y / 2
