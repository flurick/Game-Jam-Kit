tool
extends Button

export var arg:Dictionary = {"speed":8, "direction":Vector2.RIGHT}
export var code = "position += direction * speed"

signal selected(src)


func _pressed():
	emit_signal("selected", self)


func get_drag_data(position):
	
	if get_parent().name == "Actions":
		return duplicate()
	
	get_parent().remove_child(self)
	return self
