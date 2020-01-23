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
	
#	var tree_item = $Tree.create_item()
#	tree_item.set_text(0,method_name)
#	tree_item.set_cell_mode(1,TreeItem.CELL_MODE_CUSTOM)
	
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
	
#	var test = Button.new()
#	test.size_flags_vertical = SIZE_EXPAND_FILL
#	test.text = "foo"
#	row.add_child(test)


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


func _on_Button8_toggled(button_pressed):
	if button_pressed:
		$ActionPanel.popup()
	else:
		$ActionPanel.hide()

#func _on_ActionPanel_popup_hide():
#	$Button8.pressed = false


func _on_Button_selected(src):
	
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