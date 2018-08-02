extends KinematicBody2D

var velocity = Vector2(0,0)

const STARTING_VECTOR = Vector2(0,-1)
const JOYSTICK_DEADZONE = 0.2
const PLAYER_SPEED = 5
const KICK_POWER = 2

onready var ball = get_node("/root/World/Ball")
onready var ball_trajectory = get_node("BallTrajectory")

# Return a velocity normalized between -1 and 1
func input_move_velocity():
	var move = Vector2()

	move.x += Input.get_joy_axis(0, JOY_AXIS_0)
	move.y += Input.get_joy_axis(0, JOY_AXIS_1)

	if move.length() < JOYSTICK_DEADZONE:
		return null

	return move

func input_look_vector():
	var look = Vector2()

	look.x += Input.get_joy_axis(0, JOY_AXIS_2)
	look.y += Input.get_joy_axis(0, JOY_AXIS_3)

	if look.length() < JOYSTICK_DEADZONE:
		return null

	return look

func _physics_process(delta):
	var move_velocity = input_move_velocity()
	var look_vector = input_look_vector()

	if move_velocity:
		velocity = move_velocity * PLAYER_SPEED
	else:
		velocity = Vector2()

	if !look_vector:
		look_vector = move_velocity

	if look_vector:
		self.rotation = -look_vector.angle_to(STARTING_VECTOR)

	# Set position of ball trajectory indicator
	ball_trajectory.rotation = self.rotation
	ball_trajectory.position = ball.position

	move_and_collide(velocity)

	if look_vector && (ball.position - position).length() <= 32:
		ball.kick(velocity + look_vector * KICK_POWER)
