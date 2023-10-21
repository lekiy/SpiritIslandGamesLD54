class_name SelectionComponent extends Area2D

var selected := false 
var targeted := false
var mouse_over := false


@export var is_controlled_by_player := false
@onready var player_controller = get_tree().get_first_node_in_group("PlayerController")


func _on_mouse_exited():
	mouse_over = false

func _on_mouse_entered():
	mouse_over = true

func _input(event):
	if(event is InputEventMouse):
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			if(mouse_over):
				player_controller.on_right_clicked(get_parent())
			

