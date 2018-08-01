extends KinematicBody2D

var velocity = Vector2(0,0)

const STARTING_VECTOR = Vector2(0,1)
const JOYSTICK_DEADZONE = 0.25
const PLAYER_SPEED = 10

func handle_input(delta):
	var move = Vector2()

	move.x += Input.get_joy_axis(0, JOY_AXIS_0)
	move.y += Input.get_joy_axis(0, JOY_AXIS_1)

	if move.length() < JOYSTICK_DEADZONE:
		move = Vector2()

	return move

func _physics_process(delta):
	velocity = handle_input(delta)
	velocity *= PLAYER_SPEED

	self.rotation = velocity.angle_to(STARTING_VECTOR)

	var collision = move_and_collide(velocity)

	if collision:
		print("collided")
