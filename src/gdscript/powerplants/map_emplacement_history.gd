extends Resource

class_name MapEmplacementHistory

signal history_updated(history: MapEmplacementHistory)

# The actions than can be deducted from history
enum PossibleActions {
	NOTHING_HAPPENED,
	PP_BUILT,
	PP_CONSTRUCTION_STARTED,
	PP_ACTIVATED,
	PP_DEACTIVATED,
	PP_UPGRADED,
	PP_DOWNGRADED,
	PP_BUILT_AND_UPGRADED,
	PP_ACTIVATED_AND_UPGRADED,
	PP_ACTIVATED_AND_DOWNGRADED,
}

var history: Array[MapEmplacementTurnHistory]

func _init():
	history = []


func pp_construction_started(metrics: PowerplantMetrics):
	var turn_history = MapEmplacementTurnHistory.new()
	history.push_back(turn_history)
	turn_history.turn = Gameloop.current_turn
	turn_history.metrics_when_construction_started = metrics.copy()
	turn_history.pp_construction_started = true
	history_updated.emit(self)


func pp_built(metrics: PowerplantMetrics):
	var turn_history = get_history_for_turn(Gameloop.current_turn)
	
	if turn_history == null:
		turn_history = MapEmplacementTurnHistory.new()
		history.push_back(turn_history)
		turn_history.turn = Gameloop.current_turn
		
	turn_history.metrics_when_built = metrics.copy()
	turn_history.pp_built = true
	history_updated.emit(self)


func pp_construction_canceled(_metrics: PowerplantMetrics):
	# We can just delete the history for that turn
	# since building then canceling the construction
	# means nothing happened this turn
	remove_history_for_turn(Gameloop.current_turn)
	history_updated.emit(self)
	

func pp_deleted(_metrics: PowerplantMetrics):
	# We can just delete the history for that turn
	# since building then deleting
	# means nothing happened this turn
	remove_history_for_turn(Gameloop.current_turn)
	history_updated.emit(self)


func pp_activated(metrics: PowerplantMetrics):
	var turn_history: MapEmplacementTurnHistory = get_history_for_turn(Gameloop.current_turn)
	
	if turn_history == null:
		turn_history = MapEmplacementTurnHistory.new()
		history.push_back(turn_history)
		turn_history.turn = Gameloop.current_turn
		
	turn_history.pp_activated += 1
	turn_history.metrics_when_activated = metrics.copy()
	history_updated.emit(self)
	

func pp_deactivated(metrics: PowerplantMetrics):
	var turn_history: MapEmplacementTurnHistory = get_history_for_turn(Gameloop.current_turn)
	
	if turn_history == null:
		turn_history = MapEmplacementTurnHistory.new()
		history.push_back(turn_history)
		turn_history.turn = Gameloop.current_turn
		turn_history.pp_was_active_when_turn_started = true
		
	turn_history.pp_activated -= 1
	turn_history.metrics_when_deactivated = metrics.copy()
	history_updated.emit(self)
	

func pp_upgraded(metrics: PowerplantMetrics):
	var turn_history: MapEmplacementTurnHistory = get_history_for_turn(Gameloop.current_turn)
	
	if turn_history == null:
		turn_history = MapEmplacementTurnHistory.new()
		turn_history.pp_was_active_when_turn_started = true
		history.push_back(turn_history)
		turn_history.turn = Gameloop.current_turn
		
	turn_history.pp_upgrade += 1
	turn_history.metrics_when_upgraded = metrics.copy()
	history_updated.emit(self)
	

func pp_downgraded(metrics: PowerplantMetrics):
	var turn_history: MapEmplacementTurnHistory = get_history_for_turn(Gameloop.current_turn)
	
	if turn_history == null:
		turn_history = MapEmplacementTurnHistory.new()
		history.push_back(turn_history)
		turn_history.pp_was_active_when_turn_started = true
		turn_history.turn = Gameloop.current_turn
		
	turn_history.pp_upgrade -= 1
	turn_history.metrics_when_downgraded = metrics.copy()
	history_updated.emit(self)
	

func get_history_for_turn(turn: int):
	var target_history = null
	
	for turn_history in history:
		if turn_history.turn == turn:
			target_history = turn_history
			break
	
	return target_history
	
	
func remove_history_for_turn(turn: int):
	var index = 0
	var found_index = -1;
	
	for turn_history in history:
		if turn_history.turn == turn:
			found_index = index
			break;
			
		index += 1
		
	if found_index >= 0:
		history.remove_at(found_index)
		history_updated.emit(self)


func get_history_meaning(turn: int):
	var turn_history: MapEmplacementTurnHistory = get_history_for_turn(turn)
	
	if turn_history == null:
		return PossibleActions.NOTHING_HAPPENED
	else:
		if turn_history.pp_built:
			if turn_history.pp_activated == 0:# Deactivated when built
				return PossibleActions.NOTHING_HAPPENED
			elif turn_history.pp_upgrade == 0:
				return PossibleActions.PP_BUILT
			else:
				return PossibleActions.PP_BUILT_AND_UPGRADED
		elif turn_history.pp_construction_started:
			return PossibleActions.PP_CONSTRUCTION_STARTED
		else:
			# Upgraded, downgraded, activated or deactivated, or nothing
			if turn_history.pp_activated == -1:
				return PossibleActions.PP_DEACTIVATED
			elif turn_history.pp_activated == 1:
				if turn_history.pp_upgrade == 0:
					return PossibleActions.PP_ACTIVATED
				elif turn_history.pp_upgrade > 0:
					return PossibleActions.PP_ACTIVATED_AND_UPGRADED
				else:
					return PossibleActions.PP_ACTIVATED_AND_DOWNGRADED
			else:
				if not turn_history.pp_was_active_when_turn_started:
					return PossibleActions.NOTHING_HAPPENED
				else:
					# Started the turn activated
					if turn_history.pp_upgrade == 0:
						return PossibleActions.NOTHING_HAPPENED
					elif turn_history.pp_upgrade > 0:
						return PossibleActions.PP_UPGRADED
					else:
						return PossibleActions.PP_DOWNGRADED
