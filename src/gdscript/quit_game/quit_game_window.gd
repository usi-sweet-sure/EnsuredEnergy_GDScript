extends CanvasLayer

@onready var black_screen = $ClosingGameWarning/BlackScreen

# This reference will be kept until the node is freed.
# This is a ref to the callback (below) that will be used when the user is about to leave the game
# by closing the tab, the window or navigating in tab history (like going to the previous page).
var _callback_ref = JavaScriptBridge.create_callback(_before_unload_callback)


func _ready():
	# Avoid closing the game when clicking on the cross (if not fullscreen) or alt + f4 for example.
	# Only works on desktop, not web.
	# We then use the _notification function (below) to intercept the signal and
	# send our own and do what we want.
	# In our case, we display a confirmation window
	get_tree().set_auto_accept_quit(false)
	
	if OS.get_name() == "Web":
		# Get the JavaScript `window` object.
		var window = JavaScriptBridge.get_interface("window")
		# Set the `window.onbeforeunload` DOM event listener.
		window.onbeforeunload = _callback_ref
		
	Gameloop.game_quit_requested.connect(_on_game_quit_requested)
	

func _on_game_quit_requested():
	show()


func _on_confirm_button_pressed():
	if OS.get_name() == "Web":
		# This does not require the user to allow popups
		SurveyManager.open_back_to_survey_tab()
		
		# Since we can't close the tab, we display a black screen to show that the game is dead
		black_screen.show()
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
		Gameloop.game_quit_requested.emit()


# This is the callback that will be used when the user is about to leave the game
# by closing the tab, the window or navigating in tab history (like going to the previous page).
# Shows a browser alert. (Cannot be personnalized)
# It opens a tab leading back to the survey, whether the user actually leaves the game or not.
# We can't do it when the user confirms, as everything is lost.
# The user has to accept popups for the tab to open.
# This is the best we can do when the user is hard closing the tab
func _before_unload_callback(args):
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	js_event.preventDefault()
	js_event.returnValue = ''
	
	SurveyManager.open_back_to_survey_tab()
