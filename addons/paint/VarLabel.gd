tool
extends Label

export var value:int = 8  setget set_value,get_value
var is_grabbed = false
var grabbed_global_pos = Vector2.ZERO


signal value_changed(value)


func set_value(val:int):
	value = val
	update_text()
	emit_signal("value_changed",value)


func get_value():
	return value


func _ready():
	rect_min_size = Vector2.ONE * 24
	text = str(name,":",value)


func _gui_input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:  grab()
			else:  ungrab()
			return
		if event.button_index == BUTTON_WHEEL_UP:
			if event.pressed: set_value(value+1)
			return
		if event.button_index == BUTTON_WHEEL_DOWN:
			if event.pressed:  set_value(value-1)
			return

	if event is InputEventMouseMotion \
	and is_grabbed:
		set_value( value+event.relative.x )
		return
	
	if is_grabbed:
		ungrab()


func grab():
	is_grabbed = true
	grabbed_global_pos = get_global_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func ungrab():
	is_grabbed = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# warp_mouse(Vector2.ONE*-9999)
#	warp_mouse(rect_global_position+grabbed_global_pos-get_global_mouse_position())


func update_text():
	value = clamp(value, 1,1024)
	text = str(name,":",value)
