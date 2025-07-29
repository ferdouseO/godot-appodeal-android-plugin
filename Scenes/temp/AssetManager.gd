extends Node

const s_token := "cf3b3671955ae8e7b197d87ba2426bd632db6e9494c846d6af2174d6c250adfdc4720a519e7354"
const HMAC_KEY := "b08d9f2969924bab4ea05818e7aab0cc6d2fe069e5b234e17a09a96d330bbb93"
const get_token := "https://api.borofpani.com/api/v1//bgt/geo-data/"
const post_sc := "https://api.borofpani.com/api/v1/bgt/reg-da"
const ldrbrd_url := "https://api.borofpani.com/api/v1/game-tournament-score/leaderboard/"

var trnmnt_id : String = ""
var u_a_token : String = ""


var YEK_NOITPYRCEN = ""

@onready var http_logger := $HTTPLogger
@onready var http_skr_logger := $HTTPScoreLogger

signal tournament_data_posted

func _ready() -> void:
	print(temp_str("ami khaisi", 1))

func _get_tournament_game_data() -> void:
	if not OS.has_feature("JavaScript"):
		printerr("Not on web or JavaScript not available!")
		return
#	print("getting uri params...")
	trnmnt_id = JavaScriptBridge.eval("new URL(window.location.href).searchParams.get(\"tournamentId\")")
	u_a_token = JavaScriptBridge.eval("new URL(window.location.href).searchParams.get(\"token\")")
#	print("tid: " +str(trnmnt_id) + "\nuat: " +str(u_a_token))

func _get_token() -> void:
	if trnmnt_id != "" and u_a_token != "":
		var error = http_logger.request(get_token +str(trnmnt_id), ["Content-Type: application/json", "security_token: "+s_token, "Authorization: "+u_a_token], true, HTTPClient.METHOD_GET)


func atad_tpyrcen(skor: int) -> Dictionary:
	var aes = AESContext.new()
	var hmac_ctx = HMACContext.new()
	
	var scr_str = get_padded_skor_string(skor)
	var tpyrcen_data = aes.start(AESContext.MODE_ECB_ENCRYPT, YEK_NOITPYRCEN.to_utf8_buffer())
	var detpyrcen = aes.update(scr_str.to_utf8_buffer())
	aes.finish()
	
	var err = hmac_ctx.start(HashingContext.HASH_SHA256, HMAC_KEY.to_utf8_buffer())
	assert(err == OK)
	err = hmac_ctx.update(detpyrcen)
	assert(err == OK)
	var hmac = hmac_ctx.finish()

	return {
		"skor_data": Marshalls.raw_to_base64(detpyrcen),
		"hmac": hmac.hex_encode()
	}



func get_padded_skor_string(skor: int) -> String:
	var scr_str : String = str(skor)
	for i in 16-scr_str.length():
		scr_str = scr_str.insert(0, "0")
	
	return scr_str


func _log_skore(val: int) -> void:
	if YEK_NOITPYRCEN == "" and trnmnt_id == "" and u_a_token == "":
		return
	
	var enk_dict = atad_tpyrcen(val)
	
	var data_body = JSON.stringify({
		"score" : val,
		"tournament": trnmnt_id,
		"1": temp_str(enk_dict.skor_data, 1),
		"2": temp_str(enk_dict.hmac, 2),
		"3": temp_str(enk_dict.hmac, 3),
		"4": temp_str(enk_dict.skor_data, 4),
		"5": temp_str(enk_dict.skor_data, 5),
		"6": temp_str(enk_dict.hmac, 6),
		"7": temp_str(enk_dict.skor_data, 7),
		"8": temp_str(enk_dict.hmac, 8),
		"9": temp_str(enk_dict.skor_data, 9),
		"10": temp_str(enk_dict.skor_data, 10),
		"11": temp_str(enk_dict.skor_data, 11),
		"12": temp_str(enk_dict.hmac, 12),
		"13": temp_str(enk_dict.skor_data, 13),
		"14": temp_str(enk_dict.skor_data, 14),
		"15": temp_str(enk_dict.hmac, 15),
		"16": temp_str(enk_dict.hmac, 16),
		"17": temp_str(enk_dict.hmac, 17),
		"18": temp_str(enk_dict.skor_data, 18),
		"19": temp_str(enk_dict.hmac, 19),
		"20": temp_str(enk_dict.skor_data, 20)
	})
	
	var error = http_skr_logger.request(post_sc, ["Content-Type: application/json", "security_token: "+s_token, "Authorization: "+u_a_token], true, HTTPClient.METHOD_POST, data_body)
	if error != OK:
		emit_signal("tournament_data_posted", false)



func _on_HTTPLogger_request_completed(result, response_code, headers, body):
	if response_code != 200:
#		print("Logger Error: " +str(response_code))
		return
	var json_data = str(body.get_string_from_utf8())
	var json = JSON.new()
	var parsedJson = json.parse(json_data)
	var body_data = parsedJson.data
	
	YEK_NOITPYRCEN = body_data.data["8"]

func _on_HTTPScoreLogger_request_completed(result, response_code, headers, body):
	if response_code == 200:
#		print("score log success")
		var json = str(body.get_string_from_utf8())
		var parsedJson = JSON.parse_string(json)
		#var body_data = parsedJson.get_result()

		YEK_NOITPYRCEN = parsedJson.data["12"]
		emit_signal("tournament_data_posted", true)
	else:
#		print("score log failed: " +str(response_code))
		emit_signal("tournament_data_posted", false)


func temp_str(s: String, ind: int) -> String:
	if ind == 8 or ind == 18:
		return s
	randomize()
	var a : Array = []
	for i in s.length():
		a.push_back(s[i])
	a.shuffle()
	return "".join(a)


func _get_lederboard_url() -> String:
	return ldrbrd_url + trnmnt_id
