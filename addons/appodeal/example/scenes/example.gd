extends Control

@onready var test_log := $CenterContainer/VBoxContainer/TestLog
@onready var init_btn := $CenterContainer/VBoxContainer/InitializeAppodeal
@onready var int_btn := $CenterContainer/VBoxContainer/HBoxContainer2/InterstitialBtn
@onready var rew_btn := $CenterContainer/VBoxContainer/HBoxContainer2/RewardedBtn
@onready var banner_btn := $CenterContainer/VBoxContainer/HBoxContainer2/BannerBtn
@onready var load_banner_btn := $CenterContainer/VBoxContainer/HBoxContainer5/LoadBanner
@onready var app_open_btn := $CenterContainer/VBoxContainer/HBoxContainer3/AppOpenBtn
@onready var mrec_btn := $CenterContainer/VBoxContainer/HBoxContainer3/MRECBtn
@onready var native_btn := $CenterContainer/VBoxContainer/HBoxContainer3/NativeBtn
@onready var mediation_debugger_btn := $CenterContainer/VBoxContainer/MediationDebugger
@onready var main_container := $CenterContainer/VBoxContainer
@onready var banner_btn_container := $CenterContainer/VBoxContainer/HBoxContainer5
@onready var congratulations := $CenterContainer/VBoxContainer/Congratulations
@onready var banner_destroy_btn := $CenterContainer/VBoxContainer/HBoxContainer5/DestroyBanner


const APPODEAL_APP_KEY : String = "373eb28ee3a6df28440cf8a5eee7f4d3b626b9b6a05b690c"
const REWARDED_AD_ID : String = ""
const INTERSTITIAL_AD_ID : String = ""
const BANNER_AD_ID : String = ""


var interstitial_loaded : bool = false
var rewarded_loaded : bool = false
var banner_loaded : bool = false

var current_banner_position : int = 1

var appodeal : GodotAppodeal
var appodeal_listener : AppodealListener = AppodealListener.new()

func _ready():
	
	main_container.pivot_offset = main_container.size/2
	if get_viewport_rect().size.x < get_viewport_rect().size.y:
		main_container.rotation_degrees = 90
	
	if OS.get_name() != "Android":
		log_error("Platform Mismatch! Currently This Plugin supports Andrid Only!")
		return
	if Engine.has_singleton("Appodeal"):
		appodeal_listener.on_initialization_finished = _on_appodeal_initialization_finished
		
		appodeal_listener.on_interstitial_loaded = _on_appodeal_interstitial_loaded
		appodeal_listener.on_interstitial_failed_to_load = _on_appodeal_interstitial_failed_to_load
		appodeal_listener.on_interstitial_closed = _on_appodeal_interstitial_closed
		appodeal_listener.on_interstitial_shown = _on_appodeal_interstitial_shown
		appodeal_listener.on_interstitial_show_failed = _on_appodeal_interstitial_show_failed
		appodeal_listener.on_interstitial_clicked = _on_appodeal_interstitial_clicked
		appodeal_listener.on_interstitial_expired = _on_appodeal_interstitial_expired
		
		appodeal_listener.on_rewarded_video_loaded = _on_appodeal_rewarded_video_loaded
		appodeal_listener.on_rewarded_video_failed_to_load = _on_appodeal_rewarded_video_failed_to_load
		appodeal_listener.on_rewarded_video_shown = _on_appodeal_rewarded_video_shown
		appodeal_listener.on_rewarded_video_show_failed = _on_appodeal_rewarded_video_show_failed
		appodeal_listener.on_rewarded_video_finished = _on_appodeal_rewarded_video_finished
		appodeal_listener.on_rewarded_video_closed = _on_appodeal_rewarded_video_closed
		appodeal_listener.on_rewarded_video_clicked = _on_appodeal_rewarded_video_clicked
		appodeal_listener.on_rewarded_video_expired = _on_appodeal_rewarded_video_expired
		
		appodeal_listener.on_banner_loaded = _on_appodeal_banner_loaded
		appodeal_listener.on_banner_failed_to_load = _on_appodeal_banner_failed_to_load
		appodeal_listener.on_banner_shown = _on_appodeal_banner_shown
		appodeal_listener.on_banner_show_failed = _on_appodeal_banner_show_failed
		appodeal_listener.on_banner_clicked = _on_appodeal_banner_clicked
		appodeal_listener.on_banner_expired = _on_appodeal_banner_expired
		
		log_text("Appodeal plugin found!")
		init_btn.disabled = false
	else:
		log_error("Appodeal plugin not found!")
		printerr("plugin not found!")
		
	


func log_text(text: String) -> void:
	test_log.text += text +"\n"
	print(text)

func log_error(text : String) -> void:
	test_log.text += "[color=red]" +text +"[/color]" +"\n"
	printerr(text)



func _on_appodeal_initialization_finished(error: String) -> void:
	congratulations.show()
	log_text("Appodeal initialization successfull!")
	init_btn.hide()
	int_btn.disabled = false
	rew_btn.disabled = false
	banner_btn.disabled = false
	app_open_btn.disabled = false
	mrec_btn.disabled = false
	native_btn.disabled = false





func _on_appodeal_interstitial_loaded(isPrecache: bool) -> void:
	log_text("Interstitial ad loaded.")
	int_btn.text = "Show Interstitial"
	int_btn.disabled = false

func _on_appodeal_interstitial_failed_to_load(retry_attempt_count: int) -> void:
	log_error("Interstitial ad load failed! Auto Retry Attempt: %d" %retry_attempt_count)

func _on_appodeal_interstitial_shown() -> void:
	log_text("Interstitial ad Displayed.")

func _on_appodeal_interstitial_show_failed() -> void:
	log_error("Interstitial ad Display failed!")

func _on_appodeal_interstitial_clicked() -> void:
	log_text("Interstitial ad Clicked")

func _on_appodeal_interstitial_closed() -> void:
	log_text("Interstitial ad closed.")
	await get_tree().create_timer(0.5).timeout
	int_btn.text = "Load Interstitial"
	int_btn.disabled = false
	#log_text("Automatically loading the next Interstitial ad.")

func _on_appodeal_interstitial_expired() -> void:
	log_error("Interstitial ad not ready!")






func _on_appodeal_rewarded_video_loaded(isPrecache: bool) -> void:
	log_text("Rewarded ad loaded.")
	rewarded_loaded = true
	rew_btn.text = "Show Rewarded"
	rew_btn.disabled = false

func _on_appodeal_rewarded_video_failed_to_load() -> void:
	log_error("Rewarded ad load failed!")
	rew_btn.disabled = false

func _on_appodeal_rewarded_video_shown() -> void:
	log_text("Rewarded ad displayed.")

func _on_appodeal_rewarded_video_show_failed() -> void:
	log_error("Rewarded ad display failed!")

func _on_appodeal_rewarded_video_clicked() -> void:
	log_text("Rewarded ad clicked.")

func _on_appodeal_rewarded_video_finished(amount: float, rewardName: String) -> void:
	log_text("User earned reward: %s, amount: %d" %[rewardName, amount])

func _on_appodeal_rewarded_video_closed(isFinished: bool) -> void:
	log_text("Rewarded ad closed.")
	rewarded_loaded = false
	rew_btn.text = "Load Rewarded"
	rew_btn.disabled = false

func _on_appodeal_rewarded_video_expired() -> void:
	log_error("Rewarded ad not expired!")








func _on_appodeal_banner_loaded(height: int, isPrecache: bool) -> void:
	log_text("Banner ad loaded.")
	banner_loaded = true
	banner_btn.disabled = false

func _on_appodeal_banner_failed_to_load(error: String) -> void:
	log_error("Banner ad load failed! - " +error)
	banner_btn.disabled = false

func _on_appodeal_banner_shown() -> void:
	log_text("Banner ad displayed.")
	banner_destroy_btn.disabled = false

func _on_appodeal_banner_show_failed() -> void:
	log_error("Banner ad display failed!")
	banner_btn.disabled = false

func _on_appodeal_banner_clicked() -> void:
	log_text("Banner ad clicked.")

func _on_appodeal_banner_expired() -> void:
	log_text("Banner ad expired.")
	banner_loaded = false
	load_banner_btn.text = "Load Banner"
	banner_btn.disabled = false
	banner_btn_container.hide()

func _on_initialize_appodeal_pressed() -> void:
	init_btn.disabled = true
	log_text("Initializing Appodeal...")
	appodeal = GodotAppodeal.new(APPODEAL_APP_KEY, appodeal_listener)
	appodeal.setTesting(true)
	appodeal.initialize(appodeal.AdType.INTERSTITIAL | appodeal.AdType.BANNER | appodeal.AdType.REWARDED_VIDEO)


func _on_interstitial_btn_pressed() -> void:
	int_btn.disabled = true
	if appodeal.isLoaded(appodeal.AdType.INTERSTITIAL):
		appodeal.show(appodeal.AdType.INTERSTITIAL)
	#if not max_interstitial_ad:
		#max_interstitial_ad = MAXInterstitial.new(INTERSTITIAL_AD_ID, max_interstitial_listener)
		#max_interstitial_ad.load_interstitial()
		#log_text("Loading Interstitial...")
	#else:
		#if max_interstitial_ad.is_interstitila_ad_ready():
			#max_interstitial_ad.show_interstitial()
		#else:
			#max_interstitial_ad.load_interstitial()
			#log_text("Loading Interstitial...")


func _on_rewarded_btn_pressed() -> void:
	rew_btn.disabled = true
	if appodeal.isLoaded(appodeal.AdType.REWARDED_VIDEO):
		appodeal.show(appodeal.ShowStyle.REWARDED_VIDEO)
	#if not max_rewarded_ad:
		#max_rewarded_ad = MAXRewardrd.new(REWARDED_AD_ID, max_rewarded_listener)
		#max_rewarded_ad.load_rewarded()
		#log_text("Loading Rewarded...")
	#else:
		#if max_rewarded_ad.is_rewarded_ad_ready():
			#max_rewarded_ad.show_rewarded()
		#else:
			#max_rewarded_ad.load_rewarded()
			#log_text("Loading Rewarded...")


func _on_banner_btn_pressed() -> void:
	banner_btn_container.visible = not banner_btn_container.visible


func _on_app_open_btn_pressed() -> void:
	log_error("App Open Ad is not supported yet! Will be added soon.")


func _on_mrec_btn_pressed() -> void:
	log_error("MREC ad is not supported yet! Will be added soon.")


func _on_native_btn_pressed() -> void:
	log_error("Native Ad is not supported yet! Will be added soon.")


func _on_mediation_debugger_pressed() -> void:
	pass
	#max_initializer.display_mediation_debugger()








func _on_load_banner_pressed() -> void:
	banner_btn.disabled = true
	
	#if load_banner_btn.text == "Load Banner":
		#if max_adview:
			#max_adview.stop_banner_auto_refresh()
			#await get_tree().create_timer(0.5).timeout
			#max_adview.destroy_banner()
			#max_adview = null
		#max_adview = MAXAdView.new(BANNER_AD_ID, max_adview_listener, current_banner_position)
		#log_text("Loading Banner ad. Position: " +str(current_banner_position))
	#else:
		#max_adview.stop_banner_auto_refresh()
		#await get_tree().create_timer(1.5).timeout
		#max_adview.destroy_banner()
		#max_adview = null

func _on_banner_top_pressed():
	if appodeal.isLoaded(appodeal.AdType.BANNER):
		appodeal.show(appodeal.ShowStyle.BANNER_TOP)
	#current_banner_position = appodeal.ShowStyle.BANNER_TOP
	#load_banner_btn.disabled = false
	#print(banner_position)


func _on_banner_bottom_pressed():
	if appodeal.isLoaded(appodeal.AdType.BANNER):
		appodeal.show(appodeal.ShowStyle.BANNER_BOTTOM)
	#current_banner_position = appodeal.ShowStyle.BANNER_BOTTOM
	#load_banner_btn.disabled = false


func _on_banner_left_pressed():
	if appodeal.isLoaded(appodeal.AdType.BANNER):
		appodeal.show(appodeal.ShowStyle.BANNER_LEFT)
	#current_banner_position = appodeal.ShowStyle.BANNER_LEFT
	#load_banner_btn.disabled = false
	#current_banner_position = MAXBannerPosition.LEFT
	#max_plugin.switch_banner_position(banner_position.LEFT)


func _on_banner_right_pressed():
	if appodeal.isLoaded(appodeal.AdType.BANNER):
		appodeal.show(appodeal.ShowStyle.BANNER_RIGHT)
	#current_banner_position = appodeal.ShowStyle.BANNER_RIGHT
	#load_banner_btn.disabled = false
	#current_banner_position = MAXBannerPosition.RIGHT
	#max_plugin.switch_banner_position(banner_position.RIGHT)


func _on_banner_auto_refresh_btn_pressed() -> void:
	pass
	#banner_auto_refresh_btn.disabled = true
	#if max_adview.get_is_banner_auto_refresh():
		#max_adview.stop_banner_auto_refresh()
		#banner_auto_refresh_btn.text = "Start Banner Auto Refresh"
		#log_text("Banner ad auto refresh stoped!")
	#else:
		#max_adview.start_banner_auto_refresh()
		#banner_auto_refresh_btn.text = "Stop Banner Auto Refresh"
		#log_text("Banner ad auto refresh started!")
	#await get_tree().create_timer(2).timeout
	#banner_auto_refresh_btn.disabled = false

func _on_destroy_banner_pressed() -> void:
	appodeal.destroy(appodeal.AdType.BANNER)


func _on_coffee_btn_pressed():
	OS.shell_open("https://buymeacoffee.com/ferdouse_o")


func _on_toast_btn_pressed() -> void:
	if Engine.has_singleton("Appodeal"):
		appodeal.toast("mairala...")
