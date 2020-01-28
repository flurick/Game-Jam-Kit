extends Polygon2D


func _process(delta):
	position = get_global_mouse_position()


func _input(event):
	#face mouse cursor 
	if event is InputEventMouseMotion:
		scale.x = lerp( scale.x, clamp(-event.speed.x, -1, 1), 1 )
