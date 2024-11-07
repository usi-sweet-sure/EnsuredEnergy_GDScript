extends Resource

class_name MapEmplacementTurnHistory

var turn := 0
var metrics_when_construction_started: PowerplantMetrics
var metrics_when_built: PowerplantMetrics
var metrics_when_deleted: PowerplantMetrics
var metrics_when_upgraded: PowerplantMetrics
var metrics_when_downgraded: PowerplantMetrics
var metrics_when_activated: PowerplantMetrics
var metrics_when_deactivated: PowerplantMetrics
var pp_construction_started := false
var pp_was_active_when_turn_started = false
var pp_built := false
var pp_deleted := false
# -1: was active when the turn started and was then deactivated
# 0: did nothing or was built then deactivated
# 1: was deactivated when the turn started and was then activated
#    or was built this turn
var pp_activated := 0
# -n: downgraded n times
# 0: did nothing
# n: upgraded n times
var pp_upgrade := 0
