class_name Idle extends State

@export var enemy: CharacterBody2D
@export var pathing_agent: PathingComponent
@export var aggro_range: AggroRegion
@export var move_speed := 20.0
@export var wander_distance := 100.0

var move_target : Vector2
var wander_time : float

func randomize_wander():
		if(enemy):
			move_target = enemy.global_position+Vector2(randf_range(-wander_distance, wander_distance), randf_range(-wander_distance, wander_distance))
			wander_time = randf_range(1, 4)
		if(pathing_agent):
			pathing_agent.set_target(move_target)
		
func enter():
	randomize_wander()
	
func update(delta: float):
	if(aggro_range.current_target):
		transitioned.emit(self, "chase")
	
	if(wander_time > 0):
		wander_time -= delta
		
	else:
		randomize_wander()
		
func physics_update(delta: float):
	if(enemy and pathing_agent):
		enemy.velocity = pathing_agent.get_direction_to_path()*move_speed
