extends Line2D

export var target = "../body"
export var staleness = 0.3
onready var start_points = points
onready var start_offset = get_node(target).position - position


func _process(delta):
	
	
#	var scaled_offset = start_offset
#	scaled_offset.x = -get_node(target).scale.x
	points[0] = get_node(target).position# + start_offset
	
	var p: Vector2
	var last_p = points[0]
	for i in range (1, points.size()):
		
		var start_delta = start_points[i]-start_points[i-1]
		start_delta.x *= get_node(target).scale.x
		points[i] = points[i].linear_interpolate (last_p+start_delta, staleness)
		last_p = points[i]
