#@tool
class_name GodotAppodeal
extends AppodealSingletonBridge

enum AdType {
	INTERSTITIAL = 1,
	BANNER = 2,
	REWARDED_VIDEO = 4,
	MREC = 8,
}

enum ShowStyle {
	INTERSTITIAL = 1,
	BANNER_BOTTOM = 2,
	BANNER_TOP = 4,
	BANNER_LEFT = 8,
	BANNER_RIGHT = 16,
	REWARDED_VIDEO = 32,
}

enum LogLevel {
	VERBOSE = 0,
	DEBUG = 1,
	NONE = 2,
}

static var _plugin := _get_plugin("Appodeal")

var Appodeal_app_key : String = ""

const _PLUGIN_VERSION: String = "1.0"
const _PLUGIN_NAME: String = "Appodeal"


func _init(app_key : String, appodeal_listener: AppodealListener) -> void:
	Appodeal_app_key = app_key
	
	_plugin.connect("on_initialization_finished", func(error: String):	appodeal_listener.on_initialization_finished.call_deferred(error))
	_plugin.connect("on_ad_revenue_received", func(params: Dictionary):	appodeal_listener.on_ad_revenue_received.call_deferred(params))

	_plugin.connect("on_inapp_purchase_validate_success", func():	appodeal_listener.on_inapp_purchase_validate_success.call_deferred())
	_plugin.connect("on_inapp_purchase_validate_fail", func():	appodeal_listener.on_inapp_purchase_validate_fail.call_deferred())
	
	_plugin.connect("on_mrec_loaded", func():	appodeal_listener.on_mrec_loaded.call_deferred())
	_plugin.connect("on_mrec_failed_to_load", func():	appodeal_listener.on_mrec_failed_to_load.call_deferred())
	_plugin.connect("on_mrec_shown", func():	appodeal_listener.on_mrec_shown.call_deferred())
	_plugin.connect("on_mrec_show_failed", func():	appodeal_listener.on_mrec_show_failed.call_deferred())
	_plugin.connect("on_mrec_clicked", func():	appodeal_listener.on_mrec_clicked.call_deferred())
	_plugin.connect("on_mrec_expired", func():	appodeal_listener.on_mrec_expired.call_deferred())
	
	_plugin.connect("on_banner_loaded", func(height: int, isPrecache: bool):	appodeal_listener.on_banner_loaded.call_deferred(height, isPrecache))
	_plugin.connect("on_banner_failed_to_load", func():	appodeal_listener.on_banner_failed_to_load.call_deferred())
	_plugin.connect("on_banner_shown", func():	appodeal_listener.on_banner_shown.call_deferred())
	_plugin.connect("on_banner_show_failed", func():	appodeal_listener.on_banner_show_failed.call_deferred())
	_plugin.connect("on_banner_clicked", func():	appodeal_listener.on_banner_clicked.call_deferred())
	_plugin.connect("on_banner_expired", func():	appodeal_listener.on_banner_expired.call_deferred())
	
	_plugin.connect("on_interstitial_loaded", func(isPrecache: bool):	appodeal_listener.on_interstitial_loaded.call_deferred(isPrecache))
	_plugin.connect("on_interstitial_failed_to_load", func():	appodeal_listener.on_interstitial_failed_to_load.call_deferred())
	_plugin.connect("on_interstitial_shown", func():	appodeal_listener.on_interstitial_shown.call_deferred())
	_plugin.connect("on_interstitial_show_failed", func():	appodeal_listener.on_interstitial_show_failed.call_deferred())
	_plugin.connect("on_interstitial_clicked", func():	appodeal_listener.on_interstitial_clicked.call_deferred())
	_plugin.connect("on_interstitial_closed", func():	appodeal_listener.on_interstitial_closed.call_deferred())
	_plugin.connect("on_interstitial_expired", func():	appodeal_listener.on_interstitial_expired.call_deferred())
	
	_plugin.connect("on_rewarded_video_loaded", func(isPrecache: bool):	appodeal_listener.on_rewarded_video_loaded.call_deferred(isPrecache))
	_plugin.connect("on_rewarded_video_failed_to_load", func():	appodeal_listener.on_rewarded_video_failed_to_load.call_deferred())
	_plugin.connect("on_rewarded_video_shown", func():	appodeal_listener.on_rewarded_video_shown.call_deferred())
	_plugin.connect("on_rewarded_video_show_failed", func():	appodeal_listener.on_rewarded_video_show_failed.call_deferred())
	_plugin.connect("on_rewarded_video_clicked", func():	appodeal_listener.on_rewarded_video_clicked.call_deferred())
	_plugin.connect("on_rewarded_video_finished", func(amount: float, rewardName: String):	appodeal_listener.on_rewarded_video_finished.call_deferred(amount, rewardName))
	_plugin.connect("on_rewarded_video_closed", func(isFinished: bool):	appodeal_listener.on_rewarded_video_closed.call_deferred(isFinished))
	_plugin.connect("on_rewarded_video_expired", func():	appodeal_listener.on_rewarded_video_expired.call_deferred())
	#_plugin.connect("", func():	appodeal_listener.)


func toast(str: String) -> void:
	_plugin.toast(str)

#Initialization..................................
func initialize(adTypes: int) -> void:
	_plugin.setFramework(_PLUGIN_VERSION, Engine.get_version_info().string)
	_plugin.initialize(Appodeal_app_key, adTypes)


func isInitialized(adType: int) -> bool:
	return _plugin.isInitialized()



#Consent................................
func getConsentStatus() -> String:
	return _plugin.getConsentStatus()

func getCanShowPersonalizedAds() -> bool:
	return _plugin.getCanShowPersonalizedAds()

func loadAndShowConsentFormIfRequired() -> void:
	_plugin.loadAndShowConsentFormIfRequired()

func revokeUserConsent() -> void:
	_plugin.revokeUserConsent()

func updateGDPRUserConsent() -> void:
	_plugin.updateGDPRUserConsent()

func setChildDirectedTreatment(enable: bool) -> void:
	_plugin.setChildDirectedTreatment(enable)


#Caching.............................
func isAutoCacheEnabled() -> bool:
	return _plugin.isAutoCacheEnabled()

func setAutoCache(adTypes: int, enable: bool) -> void:
	_plugin.setAutoCache(adTypes, enable)

func cache(adType: int) -> void:
	_plugin.cache(adType)


#Show/hide ads............................
func isLoaded(adType: int) -> bool:
	return _plugin.isLoaded(adType)

func show(adType: int) -> void:
	_plugin.show(adType)

func showForPlacement(adType: int, placement: String = "get_free_hint") -> void:
	_plugin.showForPlacement(adType, placement)

func showBannerView(x_axis:int, y_axis:int, placement:String) -> void:
	_plugin.showBannerView(x_axis, y_axis, placement)

func hideBanner() -> void:
	_plugin.hideBanner()


func destroy(adTypes: int) -> void:
	_plugin.destroy(adTypes)


#Banner.................................
func hideBannerView() -> void:
	_plugin.hideBannerView()

func setSmartBanners(enable: bool) -> void:
	_plugin.setSmartBanners(enable)

func isSmartBannersEnabled() -> bool:
	return _plugin.isSmartBannersEnabled()

func setBannerAnimation(enable: bool) -> void:
	_plugin.setBannerAnimation(enable)

func setBannerRotation(leftRotation: int, rightRotation: int) -> void:
	_plugin.setBannerRotation(leftRotation, rightRotation)

func setUseSafeArea(enable: bool) -> void:
	_plugin.setUseSafeArea(enable)



#Testing................................
func setTesting(enable: bool) -> void:
	_plugin.setTesting(enable)

func startTestActivity() -> void:
	_plugin.startTestActivity()

func setLogLevel(logLevel : int) -> void:
	_plugin.setLogLevel(logLevel)







#
