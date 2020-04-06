extends Line2D

export var target = "../body"
export var staleness = 0.3
export var max_stretch = 10
export(float,0,1) var max_stretch_snap_back = 1
onready var start_points = points
onready var start_offset = get_node(target).position - position

export var gravity = 1 
export var wind = 1 

func _process(delta):
	
	
#	var scaled_offset = start_offset
#	scaled_offset.x = -get_node(target).scale.x
	points[0] = get_node(target).position# + start_offset
	
	var last_d = 0
	
	var p: Vector2
	var last_p = points[0]
	for i in range (1, points.size()):
		
		var start_delta:Vector2 = start_points[i]-start_points[i-1]
		
#		var d = start_delta.x
#		if gravity:
#			start_delta.x = lerp(start_delta.x, 0, gravity) #gravity
#			d -= start_delta.x
#			start_delta.y += d
#			start_delta.x *= get_node(target).scale.x
#		if wind:
#			start_delta.x += cos(OS.get_system_time_msecs()*0.01) * 10 + last_d
#		last_d = start_delta.x
		
		if points[i].distance_to(points[i-1])  < start_delta.length()*max_stretch:
			points[i] = points[i].linear_interpolate (last_p+start_delta, staleness)
		else:
#			print(start_delta.length())
			points[i] = points[i].linear_interpolate (last_p+start_delta, max_stretch_snap_back)
		
		last_p = points[i]
