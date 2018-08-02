extends KinematicBody2D

const FRICTION = 0.8
const MIN_SPEED = 0.01

var velocity = Vector2(0,0)

func _physics_process(delta):
	move_and_collide(velocity)

	velocity = velocity * (1 - (FRICTION * delta))

	if velocity.length() < MIN_SPEED:
		velocity = Vector2()

func kick(velocity):
	self.velocity = velocity
