extends Node

var game_time = 0

func _ready():
  OS.center_window()

func _physics_process(delta):
  game_time += delta
