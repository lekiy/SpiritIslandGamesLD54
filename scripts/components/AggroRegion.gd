extends Area2D

var current_target = null;

func _physics_process(delta):
	if(!current_target):
		var bodies = get_overlapping_bodies()
		var closest = null
		for body in bodies:
			if(closest == null):
				closest = body
			else:
				if(global_position.distance_to(body.global_position) < global_position.distance_to(closest.global_position)):
					closest = body
		current_target = closest

func _on_body_exited(body):
	if(current_target):
		if(body == current_target):
			current_target = null
