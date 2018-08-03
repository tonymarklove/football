extends KinematicBody2D

const FRICTION = 8

var velocity = Vector2(0,0)

func _physics_process(delta):
	move_and_collide(velocity)

	var friction_velocity_delta = (-velocity).normalized() * (FRICTION * delta)

	if velocity.length() <= friction_velocity_delta.length():
		velocity = Vector2()
	else:
		velocity = velocity + friction_velocity_delta

func kick(velocity):
	self.velocity = velocity
