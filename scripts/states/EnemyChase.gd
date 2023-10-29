class_name Chase extends State

@export var enemy: CharacterBody2D
@export var pathing_agent: PathingComponent
@export var aggro_region: AggroRegion
@export var move_speed := 40.0

func enter():
	pass
	
func update(delta: float):
	if(aggro_region.current_target):
		pathing_agent.set_target(aggro_region.current_target)
	else:
		transitioned.emit(self, "idle")
		
func physics_update(delta: float):
	if(enemy and pathing_agent):
		enemy.velocity = pathing_agent.get_direction_to_path()*move_speed
		
