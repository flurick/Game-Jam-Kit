tool
extends Panel

signal side_button_pressed(value)

func _on_Button_pressed():
   emit_signal("side_button_pressed", "Hello from side panel!")

func _on_main_button_pressed(text_to_show):
   $Label.text = text_to_show