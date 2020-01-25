tool
extends Panel


func _ready():
#	$Toolbox/HBoxContainer/Tool.value = 8
	parseBrushSelected()
	$Canvas/resize.connect("button_down",self,"_on_resize_pressed")

func parseBrushSelected():
	$Brush/TextureRect.texture = $Toolbox/HBoxContainer/Selection/HBoxContainer/Button1.group.get_pressed_button().icon


func _on_Size_value_changed(value):
	$Brush.rect_size = Vector2.ONE*value


var mod_mask
var button_mask
func _on_background_gui_input(event):
	
	if not event is InputEventMouse: return
	
	$Brush.rect_position = event.position - $Brush.rect_size*0.5
	
	if event is InputEventMouseButton:
		mod_mask = int(Input.is_key_pressed(KEY_SPACE))*32 + int(event.shift)*16 + int(event.control)*8 + int(event.alt)*4# + int(event.meta)*2 + int(event.command)*1
		button_mask = event.button_mask
		
		if button_mask == BUTTON_MASK_LEFT and mod_mask == 0:
			paint(event.global_position)
	
	
	if event is InputEventMouseMotion:
		if button_mask == BUTTON_MASK_MIDDLE:
			$Canvas.rect_position += event.relative
		
		if button_mask == BUTTON_MASK_LEFT:
#			print(mod_mask)
			match mod_mask:
				32:  $Canvas.rect_position += event.relative
				8:  $Brush.rect_size += event.relative
				24:  $Brush.rect_rotation += event.relative.x
				0:  paint(event.global_position)


func paint(position:Vector2):
	var new_dab:Control = $Brush.duplicate ()
	new_dab.rect_position = position - $Canvas.rect_global_position - $Brush.rect_size*0.5
	$Canvas.add_child (new_dab)


func _on_HSlider_value_changed(value):
	parseColorPicker()
func _on_ColorPickerButton_color_changed(color):
	parseColorPicker()
func _on_ColorPickerButton2_color_changed(color):
	parseColorPicker()
func parseColorPicker():
	var c = $Toolbox/HBoxContainer/Control/HBoxContainer/ColorPickerButton.color.linear_interpolate(\
		$Toolbox/HBoxContainer/Control/HBoxContainer/ColorPickerButton2.color, \
		$Toolbox/HBoxContainer/Control/HBoxContainer/HSlider.value)
	
	$Brush/TextureRect.modulate = c


func _on_Button1_toggled(button_pressed):
	parseBrushSelected()
func _on_Button2_toggled(button_pressed):
	parseBrushSelected()
func _on_Button3_toggled(button_pressed):
	parseBrushSelected()
func _on_Button4_toggled(button_pressed):
	parseBrushSelected()
func _on_Button5_toggled(button_pressed):
	parseBrushSelected()

var is_canvas_resizing
func _on_resize_pressed():
	is_canvas_resizing = true

func _input(event):
	if event is InputEventMouseMotion:
		if is_canvas_resizing:
			$Canvas.rect_size += event.relative
	else:
		is_canvas_resizing = false