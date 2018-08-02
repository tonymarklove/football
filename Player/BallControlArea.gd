extends Node2D

func _draw():
	draw_circle(Vector2(), 32, 0, 360, Color(0.8, 0.2, 0.2, 0.5))

func draw_circle(center, radius, angleFrom, angleTo, color):
	var nbPoints = 32
	var pointsArc = PoolVector2Array()
	pointsArc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nbPoints+1):
		var anglePoint = angleFrom + i*(angleTo-angleFrom)/nbPoints - 90
		pointsArc.push_back(center + Vector2( cos( deg2rad(anglePoint) ), sin( deg2rad(anglePoint) ) )* radius)

	draw_polygon(pointsArc, colors)
