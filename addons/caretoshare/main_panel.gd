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