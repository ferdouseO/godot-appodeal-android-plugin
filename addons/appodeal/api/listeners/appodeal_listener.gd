class_name AppodealListener

var on_initialization_finished : Callable = func(error: String): pass
var on_ad_revenue_received : Callable = func(params: Dictionary): pass

var on_inapp_purchase_validate_success : Callable = func(purchaseInfo: String): pass
var on_inapp_purchase_validate_fail : Callable = func(purchaseInfo: String): pass

var on_mrec_loaded : Callable = func(isPrecache: bool): pass
var on_mrec_failed_to_load : Callable = func(): pass
var on_mrec_shown : Callable = func(): pass
var on_mrec_show_failed : Callable = func(): pass
var on_mrec_clicked : Callable = func(): pass
var on_mrec_expired : Callable = func(): pass

var on_banner_loaded : Callable = func(height: int, isPrecache: bool): pass
var on_banner_failed_to_load : Callable = func(): pass
var on_banner_shown : Callable = func(): pass
var on_banner_show_failed : Callable = func(): pass
var on_banner_clicked : Callable = func(): pass
var on_banner_expired : Callable = func(): pass

var on_interstitial_loaded : Callable = func(isPrecache: bool): pass
var on_interstitial_failed_to_load : Callable = func(): pass
var on_interstitial_shown : Callable = func(): pass
var on_interstitial_show_failed : Callable = func(): pass
var on_interstitial_clicked : Callable = func(): pass
var on_interstitial_closed : Callable = func(): pass
var on_interstitial_expired : Callable = func(): pass

var on_rewarded_video_loaded : Callable = func(isPrecache: bool): pass
var on_rewarded_video_failed_to_load : Callable = func(): pass
var on_rewarded_video_shown : Callable = func(): pass
var on_rewarded_video_show_failed : Callable = func(): pass
var on_rewarded_video_clicked : Callable = func(): pass
var on_rewarded_video_finished : Callable = func(amount: float, rewardName: String): pass
var on_rewarded_video_closed : Callable = func(isFinished: bool): pass
var on_rewarded_video_expired : Callable = func(): pass
