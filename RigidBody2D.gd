extends RigidBody2D

export var force_to_be_used = 10000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var weak = 3000
var pos_adjustment = false
var pos_to_put
var previous_pos
var start_movement = false

# F = ma
# 

# Called when the node enters the scene tree for the first time.
func _ready():

	print(position)
	print(global_position)

func _integrate_forces(state):
	if pos_adjustment:
		pos_adjustment = false
		print(pos_to_put)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		print(global_position)
		var diff = pos_to_put - previous_pos
		start_movement = false
		state.transform = (Transform2D(0, pos_to_put))

func _physics_process(delta):
	$RayCast2D.cast_to = Vector2(force_to_be_used * delta, 0)
	$RayCast2D.force_raycast_update()
	print('vel', linear_velocity.x)
	print('delta per frame', force_to_be_used * delta)
	print('pos', global_position)

	#linear_velocity.x += 500
	if Input.is_action_just_pressed("ui_accept"):
		start_movement = true
		apply_central_impulse(Vector2(force_to_be_used, 0))
		
	if start_movement and $RayCast2D.is_colliding():
		pos_to_put = $RayCast2D.get_collision_point()
		#print('will collide!')
		#print($RayCast2D.get_collision_normal())
		#force_to_be_used = weak
		pos_adjustment = true
		previous_pos = global_position
		global_position = pos_to_put

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
