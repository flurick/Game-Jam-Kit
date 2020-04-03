tool
extends EditorPlugin

const MainPanel = preload("res://addons/template/main_panel.tscn")
const SidePanel = preload("res://addons/template/side_panel.tscn")

var main_panel_instance
var side_panel_instance

func _enter_tree():
   main_panel_instance = MainPanel.instance()
   side_panel_instance = SidePanel.instance()

   # Add the main panel to the editor's main viewport.
   get_editor_interface().get_editor_viewport().add_child(main_panel_instance)

   # Add the side panel to the Upper Left (UL) dock slot of the left part of the editor.
   # The editor has 4 dock slots (UL, UR, BL, BR) on each side (left/right) of the main screen.
   add_control_to_dock(DOCK_SLOT_LEFT_UL, side_panel_instance)

   # Hide the main panel
   make_visible(false)


func _exit_tree():
   main_panel_instance.queue_free()
   side_panel_instance.queue_free()


func _ready():
   main_panel_instance.connect("main_button_pressed", side_panel_instance, "_on_main_button_pressed")
   side_panel_instance.connect("side_button_pressed", main_panel_instance, "_on_side_button_pressed")


func has_main_screen():
   return true


func make_visible(visible):
   if visible:
      main_panel_instance.show()
   else:
      main_panel_instance.hide()


func get_plugin_name():
   return "Main Screen Plugin"


func get_plugin_icon():
   # Must return some kind of Texture for the icon.
   return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
