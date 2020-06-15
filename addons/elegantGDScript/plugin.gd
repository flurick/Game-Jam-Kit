tool
extends EditorPlugin


const SidePanel = preload("res://addons/elegantGDScript/sidebar.tscn")
var side_panel_instance

func _enter_tree():
	side_panel_instance = SidePanel.instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, side_panel_instance)
	
	ResourceLoader
	side_panel_instance.get_node("ItemList").add_item("test")

func _exit_tree():
	side_panel_instance.queue_free()
