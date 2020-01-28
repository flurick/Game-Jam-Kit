extends Polygon2D


func _process(delta):
	var t = OS.get_ticks_msec()*0.005
	position = get_global_mouse_position() + Vector2(cos(t)*-10,sin(t)*10)

#func _input(event):
#	#face mouse cursor 
#	if event is InputEventMouseMotion:
#		scale.x = lerp( scale.x, clamp(-event.speed.x, -1, 1), 1 )
