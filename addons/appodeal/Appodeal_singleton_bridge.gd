class_name AppodealSingletonBridge

static func _get_plugin(plugin_name : String) -> Object:
	if (Engine.has_singleton(plugin_name)):
		return Engine.get_singleton(plugin_name)

	if OS.get_name() == "Android":
		printerr(plugin_name + " not found, double check all the procedures.")
	else:
		printerr("Unsupported Platform! Currently this plugin supports Android only.")

	return null
