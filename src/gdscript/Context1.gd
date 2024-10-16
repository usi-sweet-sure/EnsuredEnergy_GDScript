extends Node

#the context
var ctx1
var http1

#globals
var res_id = 1
var res_name = "new123"
var yr = 2022
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
	var url = "https://sure.euler.usi.ch/json.php?mth=ins&res_name={res_name}"
	var error = http1.request(url.format({"res_name": res_name.uri_encode()}))
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
	
	
	# TODO get river and hydro avl from dsp
func get_dsp():
	var url = "https://sure.euler.usi.ch/json.php?mth=dsp"
	
#handle response
func _http1_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	ctx1 = json.get_data()
	#set globals
	#res_id = ctx1[0]["res_id"]
	#yr = ctx1[0]["yr"]
	#debug
	#print(ctx1[0]["res_id"])
	#print(ctx1[0]["yr"])
	#print(ctx1[0]["cnv_gas_gas"])
	for i in ctx1:
		print(i)
		if i["prm_id"] == "454":
			Gameloop.demand_summer = float(i["tj"]) / 100
		if i["prm_id"] == "455":
			Gameloop.demand_winter = float(i["tj"]) / 100
	
