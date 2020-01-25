tool
extends Panel

var mode = "basic"
var basic = ["_ready", "_input", "_process", "_draw", "_free" ]

func _ready():
	
	$Hint.popup()
	
	if mode == "basic":
		for method in basic:
			show_in_list(method)
	
#	for method in get_method_list():
#			if basic.has(method.name):
#		else:
#			if method.name[0] =="_":
#				var x = Button.new()
#				x.text = str(method.name)
#				$"ScrollContainer/Grid".add_child(x)


func show_in_list(method_name):
	
	var x = Button.new()
	x.text = method_name
	x.rect_min_size = Vector2.ONE * 38
	$"ScrollContainer/Grid".add_child(x)
	
	x = Panel.new()
	x.size_flags_horizontal = SIZE_EXPAND_FILL
	$ScrollContainer/Grid.add_child(x)
	
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
	row.set_script(load("res://addons/dnd/row.gd"))
	row.method_name = method_name
	row.connect("changed", self, "code_changed")
	#
	x.add_child(row)


func code_changed(src_row:HBoxContainer):
	$code.text = ""
	$code.text += str(src_row.method_name, "():\n")
	for actionsource in src_row.get_children():
		$code.text += str("\t# # # ", actionsource.text, " # # #\n")
		for arg in actionsource.arg:
			
			if str(actionsource.arg.get(arg)).length() == 0:
				$code.text += str("\tvar ", arg, "\n")
				continue
			match typeof(actionsource.arg.get(arg)):
				TYPE_INT: $code.text += str("\tvar ", arg, " = ", str(actionsource.arg.get(arg)), "\n")
				TYPE_STRING: $code.text += str("\tvar ", arg, " = ", str(actionsource.arg.get(arg)), "\n")
				TYPE_VECTOR2: $code.text += str("\tvar ", arg, " = Vector2", str(actionsource.arg.get(arg)), "\n")
				_: $code.text += str("#\t", "var ", arg, " = ", str(actionsource.arg.get(arg)), " #(unknown argument type)\n")
			
		$code.text += str("\t", actionsource.code, "\n")

var last_selected_action
func _on_Button_selected(src):
	last_selected_action = src
	$"Toolbar/HBoxContainer/Action/Title".text = str("Action: ",src.text)
	var vars = $Toolbar/HBoxContainer/Argument/ScrollContainer/Vars
	
#	if not vars: 
#		print("oops. no vars toolbox")
#		return
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
	var new_action = load ("res://Action.tscn").instance ()
	new_action.connect("selected",self,"_on_Button_selected")
	find_node ("Actions").add_child (new_action)


func _on_del_action_pressed():
	last_selected_action.queue_free()


func _on_edit_action_pressed():
#	last_selected_action.queue_free()
	if last_selected_action:
		$code.text = str(last_selected_action.arg)
		$code.text += last_selected_action.code
