extends Node

var http: HTTPRequest
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._http_completed)
	
	
func _http_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	

func perform_requests_in_sequence():
	i = 0
	
	while i < 5:
		http.request("https://api.github.com/repos/godotengine/godot/releases/latest")
		i += 1
		await http.request_completed
		
