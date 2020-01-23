tool
extends Panel


func _ready():
#	$Toolbox/HBoxContainer/Tool.value = 8
	parseBrushSelected()

func parseBrushSelected():
	$Brush/TextureRect.texture = $Toolbox/HBoxContainer/Selection/HBoxContainer/Button1.group.get_pressed_button().icon


func _on_Size_value_changed(value):
	$Brush.rect_size = Vector2.ONE*value


var brush_size = Vector2.ONE
var is_brush_resizing = false
func _on_background_gui_input(event):
	
	if Input.is_key_pressed(KEY_SPACE) \
	and event is InputEventMouseMotion:
		$Canvas.rect_position += event.relative
		return
		
	if event is InputEventMouseButton and not event.pressed:
		is_brush_resizing = false
		return
	if event is InputEventMouseButton and event.control:
		is_brush_resizing = event.pressed
		return

	if event is InputEventMouseMotion:
		if is_brush_resizing:
			brush_size += event.relative
			$Toolbox/HBoxContainer/Size.set_value( max(brush_size.x,brush_size.y) )
			return
		else:
			$Brush.rect_position = event.position - $Brush.rect_size*0.5
			return

func _on_HSlider_value_changed(value):
	parseColorPicker()
func _on_ColorPickerButton_color_changed(color):
	parseColorPicker()
func _on_ColorPickerButton2_color_changed(color):
	parseColorPicker()
func parseColorPicker():
	$Brush/TextureRect.modulate = $Toolbox/HBoxContainer/Control/HBoxContainer/ColorPickerButton.color.linear_interpolate($Toolbox/HBoxContainer/Control/HBoxContainer/ColorPickerButton2.color, $Toolbox/HBoxContainer/Control/HBoxContainer/HSlider.value)


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