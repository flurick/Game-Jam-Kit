tool
extends EditorPlugin

const MainPanel = preload("res://addons/paint/main_panel.tscn")

var main_panel_instance

func _enter_tree():
   main_panel_instance = MainPanel.instance()
   get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
   make_visible(false)

func _exit_tree():
   main_panel_instance.queue_free()
func has_main_screen():
   return true

func make_visible(visible):
   if visible:
	  main_panel_instance.show()
   else:
	  main_panel_instance.hide()

func get_plugin_name():
   return "Paint"
