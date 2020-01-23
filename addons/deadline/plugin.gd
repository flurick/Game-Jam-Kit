tool
extends EditorPlugin

const MainPanel = preload("res://addons/deadline/main_panel.tscn")
var main_panel_instance


func _enter_tree():
   main_panel_instance = MainPanel.instance()
   get_editor_interface().get_editor_viewport().add_child(main_panel_instance)


func _exit_tree():
   main_panel_instance.queue_free()


func has_main_screen():
   return true

func get_plugin_name():
   return "Deadline"