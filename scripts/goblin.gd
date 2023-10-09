extends CharacterBody2D

@export var move_speed = 50
@export var target_radius = 100
@export var health = 10
@export var attack_rate = 1
@export var attack_damage = 1
@export var attack_range = 20

@onready var world : TileMap = get_parent()
@onready var sprite = $AnimatedSprite2D
@onready var aggro_region : Area2D = $AggroRegion
@onready var pathing : PathingComponent = $PathingComponent


enum action {
	IDLE,
	ATTACK,
	MOVE,
}

var action_state = action.IDLE

const directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
var facing_direction = Vector2.DOWN

var lifetime = 0;
var attack_target: Node2D
var can_attack = true

func _process(_delta):
	match action_state:
		action.IDLE:
			if(attack_target):
				action_state = action.ATTACK

			velocity = Vector2.ZERO
			set_anim_direction("idle")
			
		action.MOVE:
			if(attack_target and position.distance_to(attack_target.position) < attack_range):
				action_state = action.ATTACK
			if(pathing.has_path):
				velocity = pathing.get_direction_to_path()*move_speed
				# sprite.rotation = deg_to_rad(pingpong(lifetime*2, 10)-5)
				set_facing_direction()
				set_anim_direction("walk")
			else:
				action_state = action.IDLE
		action.ATTACK:
			if(!attack_target or !can_attack):
				action_state = action.IDLE
			elif(position.distance_to(attack_target.position) > attack_range):
				action_state = action.MOVE
				pathing.move_to_tile(attack_target.position)
			else:
				pathing.clear_path()
				attack(attack_target)


func _physics_process(_delta):				
	move_and_slide()


func _input(event):
	if(event is InputEventMouse):
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			pass

func set_facing_direction():
	
	var closest = Vector2.DOWN
	for dir in directions:
		if(velocity.distance_to(dir) < velocity.distance_to(closest)):
			closest = dir
			
	facing_direction = closest

func attack(target):
	if(can_attack):
		can_attack = false
		target.health -= attack_damage
		await get_tree().create_timer(attack_rate).timeout
		can_attack = true

func set_anim_direction(animation_sub_name: String):
	match facing_direction:
		Vector2.DOWN:
			sprite.play(animation_sub_name+"_forward")
		Vector2.UP:
			sprite.play(animation_sub_name+"_back")
		Vector2.RIGHT:
			sprite.play(animation_sub_name+"_right")
		Vector2.LEFT:
			sprite.play(animation_sub_name+"_left")

func _on_aggro_region_body_entered(body:Node2D):
	if(!attack_target):
		if(body is Dwarf):
			attack_target = body


func _on_aggro_region_body_exited(body:Node2D):
	if(attack_target):
		if(body == attack_target):
			attack_target = null
