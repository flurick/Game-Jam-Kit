tool
extends Panel

signal main_button_pressed(value)

func _on_Button_pressed():
   emit_signal("main_button_pressed", "Hello from main screen!")

func _on_side_button_pressed(text_to_show):
   $Label.text = text_to_show
