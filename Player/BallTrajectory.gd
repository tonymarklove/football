extends Node2D

var line_color = Color(1,1,1,0.5)
var line_width = 2
var gap_length = 5
var offset = 0.0
var crawl_speed = 20
const antialiased = false

func _ready():
	set_as_toplevel(true)

func _process(delta):
	offset = offset + (crawl_speed * delta)
	update()

func _draw():
	if visible:
		draw_dotted_line(Vector2(), Vector2(0, -100), 10)

func draw_dotted_line(from, to, segment_count=1):
	if segment_count < 1: return

	var gap_count = segment_count - 1
	var line_length = (to - from).length()
	var filled_line_length = line_length - (gap_length * gap_count)
	var segment_length = filled_line_length / segment_count

	var direction = (to - from).normalized()
	var segment_vector = direction * segment_length
	var gap_vector = direction * gap_length

	if offset > segment_length + gap_length:
		offset -= segment_length + gap_length

	var segment_from = from + (direction * offset)

	for i in range(segment_count-1):
		draw_line(segment_from, segment_from + segment_vector, line_color, line_width, antialiased)
		segment_from = segment_from + segment_vector + gap_vector

	# Last segment might be split in two because of wrap-around caused by the offset
	if offset <= segment_length:
		draw_line(segment_from, to, line_color, line_width, antialiased)

	if offset > gap_length:
		draw_line(from, direction * (offset - gap_length), line_color, line_width, antialiased)
