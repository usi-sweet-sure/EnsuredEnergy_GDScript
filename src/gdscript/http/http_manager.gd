extends Node

signal http_request_active_updated(active: bool)

var http_request_active := false:
	set(new_value):
		http_request_active = new_value
		http_request_active_updated.emit(http_request_active)
#var http: HTTPRequest
#var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#http = HTTPRequest.new()
	#add_child(http)
	#http.request_completed.connect(self._http_completed)
	#
	#
#func _http_completed(_result, _response_code, _headers, _body):
	#pass
	##var json = JSON.parse_string(body.get_string_from_utf8())
	#
#
#func perform_requests_in_sequence():
	#i = 0
	#
	#while i < 5:
		#http.request("https://api.github.com/repos/godotengine/godot/releases/latest")
		#i += 1
		#await http.request_completed
		#
