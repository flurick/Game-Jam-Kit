tool
extends Panel

var view_mode = 1
var basic = ["_ready", "_input", "_process", "_draw" ]
var is_edited = false


func _ready():
	
	$Hint.popup()
	list_methods()
	list_actions()


func list_actions():
	var ui_list = $"Toolbar/HBoxContainer/Action/HBoxContainer/ScrollContainer/Actions"
	
	var d:Directory = Directory.new()
	d.open("res://addons/dnd/actions/")
	d.list_dir_begin(true)
	
	var f
	f = d.get_next()
	while f:
		ui_list.add_child( load(str("res://addons/dnd/actions/",f)).instance() )
		f = d.get_next()
		
	d.list_dir_end()


func list_methods():
	
	if view_mode:
		for method in basic:
			show_in_list(method)
			
	else:
		for method in get_method_list():
			if method.name[0] == "_":
				show_in_list(method.name)


func show_in_list(method_name):
	
	var b = Button.new()
	b.text = method_name
	b.rect_min_size = Vector2.ONE * 38
	$ScrollContainer/Grid.add_child(b)
	
	var p = Panel.new()
	p.size_flags_horizontal = SIZE_EXPAND_FILL
	$ScrollContainer/Grid.add_child(p)
	
	var row = HBoxContainer.new()
	row.size_flags_horizontal = SIZE_EXPAND_FILL
	row.size_flags_vertical = SIZE_EXPAND_FILL
	row.anchor_right = 1
	row.anchor_bottom = 1
	#
	row.margin_top = 3
	row.margin_right = -3
	row.margin_bottom = -3
	row.margin_left = 3
	#
	row.set_script (load("res://addons/dnd/row.gd"))
	row.method_name = method_name
#	row.connect("changed", self, "code_changed")
	#
	p.add_child(row)


#func code_changed(src_row:HBoxContainer):
#
#	$code.text = ""
#
#	for row in $ScrollContainer/Grid.get_children():
#		if row is Panel:
#			$code.text += parse_row(row.get_child(0))


func get_method_block(method_name):
	
	var term = str("func ", method_name)
	var result = $code.search(term, 0, 0,0)
	if result.size() == 0: 
		return {"matches":0, "first":-1, "last":-1}
	
	var first = result[TextEdit.SEARCH_RESULT_LINE]
	var last = first+1
	
	while last <= $code.get_line_count():
		if $code.get_line(last).begins_with("func")\
		or $code.get_line(last).begins_with("var")\
		or $code.get_line(last).begins_with("signal"):
			break
		last += 1
	
	return {"matches":result.size(), "first":first, "last":last}


func parse_row(row:HBoxContainer):
	
	var code = ""
	code += str("func ", row.method_name, "():\n")
	for actionsource in row.get_children():
		code += str("\t### ", actionsource.text, "_", actionsource.get_index()+1, " ###\n")
		for arg in actionsource.arg:
			
			if str(actionsource.arg.get(arg)).length() == 0:
				code += str("\tvar ", arg, "\n")
				continue
			match typeof(actionsource.arg.get(arg)):
				TYPE_INT: code += str("\tvar ", arg, " = ", str(actionsource.arg.get(arg)), "\n")
				TYPE_STRING: code += str("\tvar ", arg, " = ", str(actionsource.arg.get(arg)), "\n")
				TYPE_VECTOR2: code += str("\tvar ", arg, " = Vector2", str(actionsource.arg.get(arg)), "\n")
				_: code += str("#\t", "var ", arg, " = ", str(actionsource.arg.get(arg)), " #(unknown argument type)\n")
			
		code += str("\t", actionsource.code, "\n")
	
	code += str("\tpass\n\n")
	return code


var last_selected_action
func _on_action_selected(src):
#	print("action selected: reported by ", name)
	last_selected_action = src
	$"Toolbar/HBoxContainer/Action/Title".text = str("Action: ",src.text)
	var vars = $Toolbar/HBoxContainer/Argument/ScrollContainer/Vars
	
	$Toolbar/HBoxContainer/Argument/Title.text = src.text
	
	for old_var in vars.get_children():
		old_var.queue_free()
	
	for arg in src.arg:
		
		var arg_control_label = Label.new()
		arg_control_label.text = arg
		vars.add_child(arg_control_label)
		
		var arg_control = Label.new()
		arg_control.text = str( src.arg.get(arg) )
		vars.add_child(arg_control)


func _on_Button8_pressed():
	var new_action = load ("res://addons/dnd/actions/Template.tscn").instance()
	new_action.connect("selected",self,"_on_action_selected")
	find_node ("Actions").add_child (new_action)


func _on_del_action_pressed():
	last_selected_action.queue_free()


func _on_edit_action_pressed():
	if last_selected_action:
		$code.text = str(last_selected_action.arg)
		$code.text += last_selected_action.code


func _on_Save_pressed():
	
	$code.text = ""
	for row in $ScrollContainer/Grid.get_children():
		if row is Panel:
			$code.text += parse_row(row.get_child(0))
	
	var f = File.new ()
	f.open ($"Toolbar/HBoxContainer/File/Grid/Filename".text, File.WRITE )
	f.store_string ($code.text)
	f.close ()


func _on_CheckBox_toggled(button_pressed):
	view_mode = button_pressed
	for child in $ScrollContainer/Grid.get_children():
		child.queue_free()
	list_methods()
