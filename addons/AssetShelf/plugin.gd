tool
extends EditorPlugin

const MainPanel = preload("res://addons/caretoshare/main_panel.tscn")

var main_panel_instance

func _enter_tree():
	main_panel_instance = MainPanel.instance()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)	
	make_visible(false)


func get_project_plugins():
	
	var plugins = []
	
	var PLUGIN_PATH = "res://addons"
	var SKIP_NAVIGATIONAL = true
	var SKIP_HIDDEN_FILES = false
	var PLUGIN_CFG_FILE_NAME = "plugin.cfg"
	
	var addons_dir = Directory.new()
	
	if addons_dir.open(PLUGIN_PATH) == OK:
		addons_dir.list_dir_begin(SKIP_NAVIGATIONAL, SKIP_HIDDEN_FILES)
		var file_name = addons_dir.get_next()
		while (file_name != ""):
			if addons_dir.current_is_dir():
				var plugin_full_path = PLUGIN_PATH + "/" + file_name
				var conf_file_path = plugin_full_path + "/" + PLUGIN_CFG_FILE_NAME
				
				if addons_dir.file_exists(conf_file_path):
					var conf = ConfigFile.new()
					conf.load(conf_file_path)
					plugins.append(conf)
			file_name = addons_dir.get_next()
	else:
		print("Err: Did not reach <", PLUGIN_PATH,">")
	
	return plugins


func _exit_tree():
   main_panel_instance.queue_free()


func get_project(target_path):
	var conf = ConfigFile.new()
	conf.load(target_path)
	return {
		".godot": conf, 
		"name": conf.get_value("application","config/name"),
		"config_version": conf.get_value("","config_version"),
	}


func _ready():
#	print( get_editor_interface().get_editor_settings().get_settings_dir() ) #get all other projects from settings?
	
#	var project = get_project(OS)
	main_panel_instance.find_node("Title").text = ProjectSettings.get_setting("application/config/name")
#	main_panel_instance.find_node("config_version").text = project.config_version
	
#	print(main_panel_instance)
	for plugin in get_project_plugins():
		main_panel_instance.add_plugin(plugin)


func has_main_screen():
   return true


func make_visible(visible):
	if visible:
		main_panel_instance.show()
	else:
		main_panel_instance.hide()


func get_plugin_name():
   return "AssetShelf"
