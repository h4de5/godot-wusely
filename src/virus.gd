extends Node

class_name Virus

# how long does it take until someone can spread the virus
const time_to_infection = 20
# how long does it take for someone to see symptoms
const time_to_symptoms = 50
# how long does it take to get cured
const time_to_cure = 100

# how likely it is to infect other people
const chance_to_infection = 0.5
# how likely it is to be cured at all
const chance_to_cure = 0.9
# how likely it is to stay immune after beeing cured
const chance_to_immune = 1

# TODO - differ time and chances depending on medical system

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# if d1 and d2 meet
func meet(d1: Dot, d2: Dot):
	if d1.is_contagious && d2.:


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
