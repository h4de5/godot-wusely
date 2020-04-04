extends Node2D

var tmp = 0

func _ready():
	
	pass
	
func _physics_process(delta: float) -> void:
	var sum_speed = 0
	for host in get_tree().get_nodes_in_group("HOST"):
		sum_speed += host.direction.length()
	
	tmp += delta
	if tmp > 3:
		tmp = 0
#		print("sum speed: ",sum_speed)
