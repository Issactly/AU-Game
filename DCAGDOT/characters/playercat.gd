extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2 (0, 1)

#parameters/idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)

#update velocity
	velocity = input_direction * move_speed
#move n slide func uses velocity of char body to move char on map
	move_and_slide()
	
	
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	#dont change animation parameters if no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)

#chose new state based on whats happening with player
#couldnt figure out how to directly put in 'does not equal' sign so i just did the exclamation which does the same thing
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
