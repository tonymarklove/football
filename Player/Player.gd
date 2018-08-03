extends KinematicBody2D

const STARTING_VECTOR = Vector2(0,-1)
const JOYSTICK_DEADZONE = 0.2
const JOYSTICK_TRIGGER_DEADZONE = 0.1
const PLAYER_SPEED = 5
const DRIBBLE_KICK_SPEED = 2
const MAX_KICK_SPEED = 15
const MAX_KICK_SPEED_CHARGE_TIME = 0.8
const DELAY_AFTER_KICK = 0.5
var MAX_KICK_SPEED_CHARGE_RATE = float(MAX_KICK_SPEED) / MAX_KICK_SPEED_CHARGE_TIME

onready var ball = get_node("/root/World/Ball")
onready var ball_trajectory = get_node("BallTrajectory")

var velocity = Vector2(0,0)
var kick_speed = 1.0

var was_charging_kick_last_tick = false
var was_directing_kick_last_tick = false

var last_kick_time = 0

func input_move_velocity():
	var move = Vector2()

	move.x += Input.get_joy_axis(0, JOY_ANALOG_LX)
	move.y += Input.get_joy_axis(0, JOY_ANALOG_LY)

	if move.length() < JOYSTICK_DEADZONE:
		return null

	return move

func input_kick_vector():
	var look = Vector2()

	look.x += Input.get_joy_axis(0, JOY_ANALOG_RX)
	look.y += Input.get_joy_axis(0, JOY_ANALOG_RY)

	if look.length() < JOYSTICK_DEADZONE:
		return null

	return look

func _physics_process(delta):
	var move_velocity = input_move_velocity()
	var kick_vector = input_kick_vector()
	var kick_speed_charge_rate = Input.get_joy_axis(0, JOY_ANALOG_R2)
	var is_charging_kick = kick_speed_charge_rate > JOYSTICK_TRIGGER_DEADZONE
	var can_kick = Global.game_time > last_kick_time + DELAY_AFTER_KICK

	if is_charging_kick:
		var kick_speed_delta = (delta * kick_speed_charge_rate * MAX_KICK_SPEED_CHARGE_RATE)
		kick_speed = min(kick_speed + kick_speed_delta, MAX_KICK_SPEED)

	if move_velocity:
		velocity = move_velocity * PLAYER_SPEED
		self.rotation = -move_velocity.angle_to(STARTING_VECTOR)
	else:
		velocity = Vector2()

	# Set position of ball trajectory indicator
	ball_trajectory.position = ball.position
	ball_trajectory.line_length = 80 * kick_speed

	if kick_vector:
		ball_trajectory.rotation = -kick_vector.angle_to(STARTING_VECTOR)

	move_and_collide(velocity)

	var perform_kick = !is_charging_kick && kick_speed > 1
	var ball_within_range = (ball.position - position).length() <= 32

	if can_kick:
		if perform_kick:
			if kick_vector && ball_within_range:
				ball.kick(kick_vector * kick_speed)

			kick_speed = 1
			last_kick_time = Global.game_time

		if !perform_kick && kick_vector && ball_within_range && !is_charging_kick:
			ball.kick(velocity + kick_vector * DRIBBLE_KICK_SPEED)

	# Update "last tick" variables at the end of this tick, ready for next time
	was_charging_kick_last_tick = is_charging_kick
	was_directing_kick_last_tick = !!kick_vector
