extends Node2D

class_name Dot

onready var sprite = get_node("Sprite")


var is_contagious = false
var is_immune = false
var is_dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(Color(255, 0, 0, 255))
	pass # Replace with function body.


func set_color(color: Color):
	sprite.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
