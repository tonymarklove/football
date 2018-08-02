extends Camera2D

var viewport_size = null
var viewport_half_size = null

onready var player = get_node("/root/World/Player")
onready var ball = get_node("/root/World/Ball")

func _ready():
	viewport_size = get_viewport().size
	viewport_half_size = viewport_size / 2

func _physics_process(delta):
	var player_to_ball_x_distance = abs(player.position.x - ball.position.x)
	var x_scale = 1.0

	if player_to_ball_x_distance:
		x_scale = (viewport_size.x * 0.9) / player_to_ball_x_distance

	var player_to_ball_y_distance = abs(player.position.y - ball.position.y)
	var y_scale = 1.0

	if player_to_ball_y_distance:
		y_scale = (viewport_size.y * 0.9) / player_to_ball_y_distance

	var scale_factor = x_scale if x_scale < y_scale else y_scale

	if scale_factor > 1:
		scale_factor = 1

	var zoom = 1/scale_factor

	self.position = player.position.linear_interpolate(ball.position, 0.5)
	self.set_zoom(Vector2(zoom, zoom))
