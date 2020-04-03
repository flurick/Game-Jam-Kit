tool
extends EditorPlugin

const SidePanel = preload("res://addons/LemonShop/LemonShop.tscn")
var side_panel_instance

func _enter_tree():
	side_panel_instance = SidePanel.instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, side_panel_instance)

func _exit_tree():
	side_panel_instance.queue_free()
