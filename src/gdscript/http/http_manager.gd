extends Node

signal http_request_active_updated(active: bool)
signal http_request_completed(result, response_code, headers, body)


var http_request_active := false:
	set(new_value):
		http_request_active = new_value
		http_request_active_updated.emit(http_request_active)
		
var http1: HTTPRequest


# Called when the node enters the scene tree for the first time.
func _ready():
	http1 = HTTPRequest.new()
	add_child(http1)
	http1.request_completed.connect(_on_http1_request_completed)
	

func make_request(url: String):
	http_request_active = true
	http1.request(url)


func _on_http1_request_completed(result, response_code, headers, body):
	http_request_active = false
	http_request_completed.emit(result, response_code, headers, body)
