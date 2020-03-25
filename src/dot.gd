extends Node2D

class_name Dot

onready var sprite = get_node("Sprite")

var infections: Array = Array()

# whener a dot is dead
var is_dead : bool = false setget set_dead

func set_dead(val: bool):
	pass

# when a dot is infected by a virus, it get added to the list of infections
func infect(virus: Virus):
	var infection : Infection
	infection.virus = virus
	infection.is_
	infections.append(infection)
	
	

# if d1 and d2 meet
func meet(encounter: Dot):
	if d1.is_contagious and d2.is_vulnerable:
		if chance(chance_to_infection):
			d2.infect(self)
		
	elif d2.is_contagious and d1.is_vulnerable:
		d1.is_infected = chance(chance_to_infection)
		
	#if d1.is_contagious && d2.:
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(Color(255, 0, 0, 255))
	pass # Replace with function body.

func set_color(color: Color):
	sprite.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
