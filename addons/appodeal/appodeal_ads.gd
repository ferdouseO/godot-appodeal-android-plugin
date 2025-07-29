extends Node



const APPODEAL_APP_KEY : String = ""
const REWARDED_AD_ID : String = ""
const INTERSTITIAL_AD_ID : String = ""
const BANNER_AD_ID : String = ""


var interstitial_loaded : bool = false
var rewarded_loaded : bool = false
var banner_loaded : bool = false

var current_banner_position : int = 1

var appodeal : GodotAppodeal
var appodeal_listener : AppodealListener = AppodealListener.new()

signal rewarded_ad_loaded
signal rewarded_ad_closed
signal interstitial_ad_closed
signal interstitial_ad_show_failed

func _ready():
	
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
		#_initialize_appodeal()
	else:
		log_error("Appodeal plugin not found!")
		
	


func log_text(text: String) -> void:
	print(text)

func log_error(text : String) -> void:
	printerr(text)



func _on_appodeal_initialization_finished(error: String) -> void:
	if error == null or error == "":
		log_text("Appodeal initialization successfull!")
	else:
		log_error("Appodeal initialiazation error: " +error)





func _on_appodeal_interstitial_loaded(isPrecache: bool) -> void:
	log_text("Interstitial ad loaded.")

func _on_appodeal_interstitial_failed_to_load(retry_attempt_count: int) -> void:
	log_error("Interstitial ad load failed! Auto Retry Attempt: %d" %retry_attempt_count)

func _on_appodeal_interstitial_shown() -> void:
	log_text("Interstitial ad Displayed.")

func _on_appodeal_interstitial_show_failed() -> void:
	log_error("Interstitial ad Display failed!")
	emit_signal("interstitial_ad_show_failed")

func _on_appodeal_interstitial_clicked() -> void:
	log_text("Interstitial ad Clicked")

func _on_appodeal_interstitial_closed() -> void:
	log_text("Interstitial ad closed.")
	emit_signal("interstitial_ad_closed")
	await get_tree().create_timer(0.5).timeout
	#log_text("Automatically loading the next Interstitial ad.")

func _on_appodeal_interstitial_expired() -> void:
	log_error("Interstitial ad not ready!")






func _on_appodeal_rewarded_video_loaded(isPrecache: bool) -> void:
	log_text("Rewarded ad loaded.")
	emit_signal("rewarded_ad_loaded")

func _on_appodeal_rewarded_video_failed_to_load() -> void:
	log_error("Rewarded ad load failed!")

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
	emit_signal("rewarded_ad_closed", isFinished)

func _on_appodeal_rewarded_video_expired() -> void:
	log_error("Rewarded ad not expired!")








func _on_appodeal_banner_loaded(height: int, isPrecache: bool) -> void:
	log_text("Banner ad loaded.")

func _on_appodeal_banner_failed_to_load(error: String = "") -> void:
	log_error("Banner ad load failed! - " +error)

func _on_appodeal_banner_shown() -> void:
	log_text("Banner ad displayed.")

func _on_appodeal_banner_show_failed() -> void:
	log_error("Banner ad display failed!")

func _on_appodeal_banner_clicked() -> void:
	log_text("Banner ad clicked.")

func _on_appodeal_banner_expired() -> void:
	log_text("Banner ad expired.")





func _initialize_appodeal() -> void:
	if OS.get_name() != "Android" and not Engine.has_singleton("Appodeal"):
		return
	log_text("Initializing Appodeal...")
	appodeal = GodotAppodeal.new(APPODEAL_APP_KEY, appodeal_listener)
	appodeal.setTesting(false)
	appodeal.setLogLevel(appodeal.LogLevel.VERBOSE)
	appodeal.initialize(appodeal.AdType.INTERSTITIAL | appodeal.AdType.REWARDED_VIDEO | appodeal.AdType.BANNER)



func _is_loaded(ad_type: int) -> bool:
	return appodeal and appodeal.isLoaded(ad_type)


func _show_interstitial() -> void:
	if appodeal and appodeal.isLoaded(appodeal.AdType.INTERSTITIAL):
		appodeal.show(appodeal.AdType.INTERSTITIAL)


func _show_rewarded() -> void:
	if appodeal and appodeal.isLoaded(appodeal.AdType.REWARDED_VIDEO):
		appodeal.show(appodeal.ShowStyle.REWARDED_VIDEO)








func _show_banner(ad_style: int) -> void:
	if appodeal and appodeal.isLoaded(appodeal.AdType.BANNER):
		appodeal.show(ad_style)



func _destroy_banner() -> void:
	appodeal.destroy(appodeal.AdType.BANNER)

func _hide_banner_view() -> void:
	appodeal.hideBannerView()
