tool
extends Control

signal changed(src)
export var method_name = "???"

func can_drop_data(pos, data):
	return typeof(data) == TYPE_OBJECT

func drop_data(position, data):
	add_child(data)
	emit_signal("changed", self)