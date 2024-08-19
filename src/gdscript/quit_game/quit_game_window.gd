extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Avoid closing the game when clicking on the cross (if not fullscreen) or alt + f4 for example.
	# Only works on desktop, not web.
	# We then use the _notification function to intercept the signal and do what we want.
	# In our case, we display a confirmation window
	get_tree().set_auto_accept_quit(false)
	
	# Intercepts when the user is about to leave the game by closing the tab, the window
	# or navigating in tab history (like going to the previous page).
	# Shows a browser alert. (Cannot be personnalized)
	# It opens a tab back to the survey right away, wether the user leaves or not.
	# We can't do it when the user confirms, as everything is lost.
	# The user has to accept popups for the tab to open.
	# This is the best we can do when the user is hard closing the tab
	if OS.get_name() == "Web":
		if SurveyManager.token != "":
			JavaScriptBridge.eval("window.addEventListener('beforeunload', function (e) {
					e.preventDefault();
					e.returnValue = '';
					window.open('https://unibe.eu.qualtrics.com/jfe/form/SV_2lvvzqrI2fWxiwC?keyback={tok}', '_blank')
				});".format({"tok": SurveyManager.token}))
		else:
			JavaScriptBridge.eval("window.addEventListener('beforeunload', function (e) {
					e.preventDefault();
					e.returnValue = '';
				});")
			
	Gameloop.game_quit_requested.connect(_on_game_quit_requested)
	

func _on_game_quit_requested():
	show()


func _on_confirm_button_pressed():
	if OS.get_name() == "Web":
		# This does not require the user to allow popups
		SurveyManager.open_back_to_survey_tab()
		get_tree().quit()
	else:
		# Nothing special to do on desktop, we just leave the game
		get_tree().quit()

	
func _on_cancel_button_pressed():
	hide()
	
	
# Intercepts closing notification from OS.
# Doesn't work when closing tab on web but work on desktop with alt + f4 for example
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		show()
