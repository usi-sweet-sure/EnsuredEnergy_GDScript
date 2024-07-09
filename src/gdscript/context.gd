extends Node

#the context
var ctx1
var http1

#globals
var res_id = 1
var yr = 2035
var prm_id = 186
var tj = 8000

#init
func _ready():
	http1 = HTTPRequest.new()
	add_child(http1)
	http1.request_completed.connect(self._http1_completed)
	#res_ins()
	#prm_ups()
	get_ctx()
	
	
#new game	
func res_ins():
	var url = "https://sure.euler.usi.ch/json.php?mth=ins"
	var error = http1.request(url)
	if error != OK:
		push_error("http error")
		
#upsert param
func prm_ups():
	var url = "https://sure.euler.usi.ch/json.php?mth=ups&res_id={res_id}&prm_id={prm_id}&yr={yr}&tj={tj}"
	var error = http1.request(url.format({"res_id": res_id, "yr": yr, "prm_id": prm_id, "tj": tj}))
	if error != OK:
		push_error("http error")
	
		
#you dont need this function - res_ins or prm_ups returns the context
func get_ctx():
	var url = "https://sure.euler.usi.ch/json.php?mth=ctx&res_id={res_id}&yr={yr}"
	var error = http1.request(url.format({"res_id": res_id, "yr": yr}))
	if error != OK:
		push_error("http error")
	
	
#handle response
func _http1_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	ctx1 = json.get_data()
	#set globals
	res_id = ctx1[0]["res_id"]
	yr = ctx1[0]["yr"]
	#debug
	print(ctx1[0]["res_id"])
	print(ctx1[0]["yr"])
	print(ctx1[0]["cnv_gas_gas"])
