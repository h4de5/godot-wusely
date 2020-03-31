extends Node2D
#extends Reference

# class_name Host

const COLOR_BASE = Color(255, 255, 255, 255)

#const Virus = preload("res://src/virus.gd")
#const Infection = preload("res://src/infection.gd")

# TODO - get each host a randomize name

onready var sprite = get_node("Sprite")

var infections: Array = Array()

# whener a dot is dead
var is_dead : bool = false setget set_dead

func set_dead(val: bool):
	is_dead = val

# when a dot is infected by a virus, it get added to the list of infections
func infect(virus):
	#var infection : Infection
	# create a new infection based on given virus
	var infection = load("res://src/infection.gd").new()
	# TODO - change here to duplicate/clone - instead of ref
	infection.virus = virus
	infection.host = self
	# add infection to hosts list
	infections.append(infection)

	# infection.connect("SIGNAL_VULNERABLE", infection, "on_contagion")
	# infection.emit_signal("SIGNAL_CONTAGIOUS")
	
	# return it, for later use..
	return infection

# check if a virus can infect the host
func infectable(virus):
#func infectable(virus):
	var is_vulnerable = true
	# TODO - even a dead body could be vulnerable
	if is_dead:
		is_vulnerable = false
	elif len(infections) > 0:
		# if i have the virus in question
		# and if I am immune
		# than I cannot get the virus again
		for infection in infections:
			if infection.virus == virus and \
				infection.is_vulnerable:
				is_vulnerable = false
				break
	return is_vulnerable

# if dot meets another dot
func meet(encounter):
	
	# go through all my current infections
	# check if encounter is voluarable 
	if len(infections) > 0:
		for infection in infections:
			# for each infection that is still contagious
			# check if the encounter is still vulnerable
			# and infect encounter only if chance is successfull
			if infection.is_contagious and \
				encounter.infectable(infection.virus) and \
				infection.virus.chance(infection.virus.chance_of_infection):
				encounter.infect(infection.virus)
			
#	if d1.is_contagious and d2.is_vulnerable:
#		if chance(chance_to_infection):
#			d2.infect(self)
#
#	elif d2.is_contagious and d1.is_vulnerable:
#		d1.is_infected = chance(chance_to_infection)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_color(Color(255, 0, 0, 255))
	pass # Replace with function body.

func set_color(color: Color):
	sprite.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
