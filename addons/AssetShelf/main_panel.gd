extends Panel

func add_plugin(plugin:ConfigFile): 
	var p = find_node("plugin").duplicate()
	p.find_node("name").text = plugin.get_value("plugin", "name")
	p.find_node("name").hint_tooltip = str("By: ",plugin.get_value("plugin", "author") )
	p.find_node("version").text = plugin.get_value("plugin", "version")
	$VBoxContainer.margin_bottom = 0
	
#	$VBoxContainer.add_child(p)
	p.visible = true
	
#	plugin.get_value("plugin","name"), plugin.get_value("plugin","version") )

func _ready():
	
	for project_path in read_system_project_list():
		var new_project_item = $"ScrollContainer/VBoxContainer/project".duplicate()
		var new_project_data = read_project_data(project_path)
		print(new_project_data.as_text())
		
		var p = project_path
		p = p.lstrip("\"")
		p = p.rstrip("\"")
		new_project_item.get_node("Title").text = p.split("/")[-1]
		
		new_project_item.get_node("Title").hint_tooltip = new_project_data.config_path
		new_project_item.get_node("engine/version_number").text = new_project_data.config_version
		if new_project_data.warning:
			new_project_item.get_node("warning").text = new_project_data.warning
			new_project_item.get_node("warning").show()
		else:
			new_project_item.get_node("warning").hide()
			
		new_project_item.show()
		$ScrollContainer/VBoxContainer.add_child(new_project_item)



class Project:
	var config_name:String
	var config_path:String
	var config_version:String
	var warning:String
	func as_text():
		return str("name:",config_name, "version:",config_version)


func read_project_data(path:String) -> Project:
	
	var project = Project.new()
	var config = ConfigFile.new()
	path = path.lstrip("\"")
	path = path.rstrip("\"")
	path = str(path, "\\", "project.godot")
	var err = config.load(path)
	if err == OK:
		project.config_name = config.get_value("application", "config/name")
		project.config_path = path
		project.config_version = config.get_value("", "config_version")
	else:
		project.warning = err
	return project


func read_system_project_list():
	match OS.get_name():
		"Windows":  return read_windows_project_list()
		_: print("Error: Unknown project list location")

func read_windows_project_list():
	var file = File.new()
	var home_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	home_path = home_path.trim_suffix("Documents")
	home_path += "AppData\\Roaming\\Godot\\"
	home_path += "editor_settings-3.tres" #TODO: this is probably not a static name?
	print("Reading projects from ", home_path)
	file.open(home_path, File.READ)
	var content = file.get_as_text()
	
	var line:String = ""
	var projects = []
	while not file.eof_reached():
		line = file.get_line()
		if line.begins_with("projects") \
		or line.begins_with("\"projects"):
			projects.append( line.split(" = ")[1] )
	
	file.close()
	return projects
